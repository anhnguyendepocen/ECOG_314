#to insert library 
#library(ggplot2)
setwd("~/Desktop/RECOG314/Midterm/Midterm_Project_data")
Poverty_inflation <- read.csv("Poverty_inflation.csv")
head(Poverty_inflation)
#renaming variables in r because the name is too long
names(Poverty_inflation)[2]<-c("Poverty")   
#summary statistics 
summary(Poverty_inflation)
#Ordering varibles by year in ascending order 
Poverty_inflation <- Poverty_inflation[order(Poverty_inflation$Year),]
#Creating a new variable using information from an old variable
#First create a the lag of CPI or CPIt-1 
Poverty_inflation$CPIlag <- c(NA,Poverty_inflation$CPI[1:(length(Poverty_inflation$CPI)-1)])
#Then calculate the inflation rate naming it "Rate of inflation" 
Poverty_inflation$RateofInflation <- (Poverty_inflation$CPI-Poverty_inflation$CPIlag)/Poverty_inflation$CPIlag
#graph year inflation
graph_inflation <- ggplot(data = Poverty_inflation) + geom_point(aes(x=Year, y=Inflation.Rate))
graph_inflation
graph_inflation_poverty <- ggplot(data = Poverty_inflation) + geom_point(aes(x=Year, y=Inflation.Rate))+ geom_point(aes(x=Year, y=Poverty))
graph_inflation_poverty
#correlation between poverty and inflation
cor(Poverty_inflation$Poverty,Poverty_inflation$Inflation.Rate)
#subsetting ->looking at data post 1980 
Poverty_inflation_post1980 <-Poverty_inflation[Poverty_inflation$Year>=1980,]
#correla
cor(Poverty_inflation_post1980$Poverty,Poverty_inflation_post1980$Inflation.Rate)
#1980 Graphs
#graph_Poverty_inflation_post1980 <- ggplot(data = Poverty_inflation_post1980) + geom_point(aes(x=Year, y=Inflation.Rate))+ geom_point(aes(x=Year, y=Poverty))
#graph_Poverty_inflation_post1980
Poverty_interestrate <- read.csv("interestrate.csv")
Poverty=merge(Poverty_inflation,Poverty_interestrate,by="Year") 
#graph_interest rates
graph_interestrate<- ggplot(data = Poverty_intrestrate) + geom_point(aes(x=Year, y=InterestRate))
graph_interestrate
Poverty_intrestrate <- Poverty_intrestrate[order(Poverty_intrestrate$Year),]
graph_poverty_intrestrate<- ggplot(data = Poverty_intrestrate) + geom_point(aes(x=Year, y=InterestRate)) + geom_point(aes(x=Year, y=Poverty))
graph_poverty_intrestrate
