#Data Import
indicators <- read.csv("Indicators.csv")
school_reports <- read.csv("CPS_School_Reports.csv")
school_locations <- read.csv("CPS_School_Locations.csv")
misconduct <- read.csv("Misconduct.csv")


#Clean Up the Data

names(indicators) <- c("Community_Area_Number","Community_Area_Name","Housing_Crowded","Households_Below_Poverty","Age_16_Unemployed","Age_25_wo_Diploma","Under_18_over_64","Per_Capita_Income","Hardship_Index")
indicators


school_locations <- school_locations[c(3,4,8,13:14)]
school_locations

school_locations <- school_locations[c(1,4:5)]
school_locations

colnames(misconduct)[colnames(misconduct)=="School.ID"] <-"School_ID"
misconduct

schools = merge(school_locations,misconduct)
schools

colnames(schools)[colnames(schools)=="COMMAREA"] <-"Community_Area_Name"
schools

indicators$Community_Area_Name <-tolower(indicators$Community_Area_Name)
schools$Community_Area_Name <-tolower(schools$Community_Area_Name)

merge(schools,indicators, by="Community_Area_Name")
alldata = merge(schools,indicators, by="Community_Area_Name")
alldata


#Aggregate Data

aggregate = aggregate(alldata$Expulsions.per.100.Students, by=list((alldata$Community_Area_Name)),FUN=mean)

alldata <- alldata[!is.na(alldata$Expulsions.per.100.Students) | !is.na(alldata$Community_Area_Name),]
aggregate <-aggregate[order(aggregate$x),]
aggregate

alldata$totalexpulsion <- (alldata$Expulsions.per.100.Students)*(alldata$X..of.Students.Expelled)
alldata


aggregate2 = aggregate(alldata$totalexpulsion, by=list((alldata$Community_Area_Name)),FUN=mean)

aggregate3 = aggregate(alldata$totalexpulsion, by=list((alldata$School_ID)),FUN=mean)

aggregate4 = aggregate(alldata$totalexpulsion, by=list((alldata$Network)),FUN=mean)


#GRAPHS

library(ggplot2)


ggplot(indicators,aes(x=Hardship_Index, y=Age_25_wo_Diploma)) + 
  geom_point()
  ggtitle("Correlation between Education and Hardship Index")

  
ggplot(indicators,aes(x=Hardship_Index, y=Age_16_Unemployed)) + 
    geom_point()
  ggtitle("Correlation between Education and Hardship Index")
 
  
ggplot(indicators,aes(x=Hardship_Index, y=Per_Capita_Income)) + 
    geom_point()
  ggtitle("Correlation between Income and Hardship Index") 


ggplot(indicators,aes(x=aggregate$x, y=Age_25_wo_Diploma)) + 
  geom_point()
ggtitle("Correlation between Expulsions and Hardship Index") 


ggplot(aggregate,aes(reorder(x=Group.1, -x), y=x)) + 
  geom_bar(stat="identity") +
ggtitle("Average Expulsions per 100 Students") +
  xlab("Community Area")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ylab("")


ggplot(aggregate2,aes(reorder(x=Group.1, -x), y=x)) + 
  geom_bar(stat="identity") +
  ggtitle("Average Number of Expulsions") +
  coord_flip() +
  xlab("Community Area")+
  ylab("")


ggplot(aggregate4,aes(reorder(x=Group.1, -x), y=x)) + 
  geom_bar(stat="identity") +
  ggtitle("Average Number of Expulsions") +
  xlab("Network")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ylab("")


ggplot(aggregate5,aes(reorder(x=Group.1, -x), y=x)) + 
  geom_bar(stat="identity") +
  ggtitle("Average Number of Misconducts") +
  coord_flip() +
  xlab("Community Area")+
  ylab("")

ggplot(indicators,aes(reorder(x=Community_Area_Name,Hardship_Index), y=Hardship_Index)) + 
  geom_bar(stat="identity") +
  ggtitle("Hardship Index") +
  xlab("Community Area")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ylab("")


#Summary Statistics

summary(alldata)
summary(alldata$Hardship_Index)
summary(indicators$Age_25_wo_Diploma)
summary(alldata$Expulsions.per.100.Students)
summary(alldata$X..of.Students.Expelled)

tail(aggregate2[order(aggregate2$x),])
tail(aggregate[order(aggregate$x),])
tail(indicators[order(indicators$Hardship_Index),])