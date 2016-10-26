setwd("~/Desktop/project1")
install.packages("psych")
library(psych)
library(data.table)
library(dplyr)
library(ggplot2)
library(scales)
?fread
immigrationdata <-fread("usa_00007.csv",stringsAsFactors=FALSE)
caribbean <-c(26030,26042,26044,26055,26057,26058,26060,30040,26054,26059,30055)
people_caribbean <- immigrationdata[which(immigrationdata$BPLD %in% caribbean),]
str(people_caribbean)
unique(people_caribbean$YEAR)
unique(people_caribbean$PERNUM)
unique(people_caribbean$PERWT)
years <- c(2000:2014)
Caribbean_nationals <- c()
country_num <- c()
year <- c()
k <- 1
for(country in caribbean){
  temp_country <- people_caribbean[people_caribbean$BPLD==country,]
  for (i in years){
    temp_year <-temp_country[temp_country$YEAR==i,]
    Caribbean_nationals[k] <-sum(temp_year$PERWT)
    country_num[k] <-country
    year[k] <-i
    k <-k+1
  }
}

population_over_time <- data.frame(Caribbean_nationals,BPLD=country_num,year)
mergedata <-fread("mergefile_birthplace.csv")
country_of_origin <- merge(population_over_time, mergedata, by="BPLD")
names(country_of_origin)[4] <- c("country")


ggplot(data=country_of_origin)+
  geom_line(aes(x=year,y=Caribbean_nationals,color=country))+
  scale_y_continuous(labels= scales::comma)
 group_by(people_caribbean,YEAR, BPLD)+ ggtitle("Caribbean Emigration to the United States") +
   xlabs("Year")+ ylab("Migrant Population")

 age <- c()
 year <- c()
 k <- 1
 for(country in caribbean){
   age <- people_caribbean[people_caribbean$AGE==country,]
   for (i in years){
     temp_year <-age[age$YEAR==i,]
     age[k] <-sum(temp_year$PERWT)
     country_num[k] <-country
     year[k] <-i
     k <-k+1
   }
 }
 head(people_caribbean)
 
 
 mean_age <- aggregate(people_caribbean, list(people_caribbean$BPLD, people_caribbean$YEAR, people_caribbean$AGE), mean)
 
 mergedata <-fread("mergefile_birthplace.csv")
 names(mergedata)<-c("BPLD","birthplace")
 mean_age <- merge(people_caribbean, mergedata, by="BPLD") %>% 
   group_by(birthplace, YEAR) %>%
   summarize(average_age = mean(AGE),SD_age = sd(AGE)) %>%
   data.frame()
 
 mean_age$birthplace <- as.factor(mean_age$birthplace)
 p <- subset(mean_age, as.character(birthplace) %in% c("Jamaica", "Guyana/British Guiana","Grenada")) %>%
   ggplot(mapping = aes(x = YEAR, y = average_age, fill = birthplace)) +
   geom_bar(stat="identity",position="dodge") + 
   #geom_errorbar(aes(ymin=average_age - SD_age, ymax= average_age + SD_age))+
   xlab("Year") + ylab("Average Age")+ ggtitle("Average Age of Immigrants to the United States (2000-2014)")
 p
 people_caribbean$isfemale <- 0
 people_caribbean[people_caribbean$SEX ==2,]$isfemale <-1
 people_caribbean$male <-0
 people_caribbean[people_caribbean$isfemale == 0,]$male <-1
 
 names(mergedata) <- c("BPLD","birthplace")
 
 Gender <- merge(people_caribbean, mergedata, by="BPLD") %>% 
   group_by(birthplace, YEAR) %>%
   summarize( num_female = sum(isfemale*PERWT), num_male = sum(male*PERWT)) %>%
   data.frame()
 Gender$birthplace <-as.factor(Gender$birthplace)
 ggplot(data=Gender, aes(x=YEAR, y= num_female))+ geom_point()
 Gender$ratio <-Gender$num_female/Gender$num_male
 ggplot(data = Gender, aes(x=YEAR, y=ratio, color =birthplace))+ geom_line()
 Gender$birthplace <- NULL
 average_gender <- aggregate(Gender, list(Gender$YEAR), sum)
 average_gender$ratio <-average_gender$num_female/average_gender$num_male
 gplot(data=average_gender, aes(x=Group.1,y=ratio)) + 
   geom_line()+ xlab("Years")+ ylab("Ratio of Women to Men")+ggtitle("Gender Ratio Over Time")
 
 brain_drain <-people_caribbean[people_caribbean$EDUC>6,]
 yearly_braindrain <- aggregate(brain_drain$EDUC*brain_drain$PERWT, list(brain_drain$YEAR), sum)
 
 ggplot(data=yearly_braindrain, aes(x=Group.1,y=x/1000 ))+ 
   geom_bar(stat="identity",fill=" dark green", color ="black")+ 
   xlab("Years")+
   ylab(" Number of Immigrants with Tertiary Educational Level in Thousands")
 
 describe(people_caribbean)
 