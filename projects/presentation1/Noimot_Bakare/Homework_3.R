setwd("/Users/NomiB/Desktop/RECOG314/Homeworks/Homework_3\ /")
exchngrate <- read.csv("FRB_Z1.csv")
head(exchngrate)
annualexrate <- data.frame(exchngrate$Descriptions.,exchngrate$Unit.,exchngrate$Multiplier.,exchngrate$Currency.,exchngrate$Unique.Identifier.,exchngrate$Series.Name.)
head(annualexrate)
head(exchngrate)
#install.packages("zoo") #"" there is exactly what I want
library(zoo) #library tells R to bring it up 
annualexrate.xts #.xts is FOR ME to know that I am changing my data to annual data.
#create a data set 1:8 
my.data <- 1:8
#create a fake data set
fake.ts <- ts(my.data, start = c(1959,1), frequency = 4)
#to create my data on the fly 
#fake2.ts <- ts(2:16, start = c(1959,1), frequency = 4)
#to check the class of your data set meaning times series, numeric etc. 
class(fake.ts)
#Print fake.ts #in order to display content print(fake.ts) or fake.ts
fake.ts
#to be able to use window (which is below) use zoo
#window will display a time frame that I specify 
#we need to convert from ts to xts, because xts has more capabilities 
#install xts
install.packages("xts")
library(xts)
fake.xts <- as.xts(fake.ts)
class(fake.xts)
print(fake.xts)
window(fake.xts, start='1959 Q2', end='1959 Q4')

#aggregating data by year -- convert quarterly 
time <-index(fake.xts)
#index gives date
#core data will give the actual data leaving date out so that you can split btwn date and the data
#this is necessary to aggregate the data
data<- coredata(fake.xts)
coredata(fake.xts)


