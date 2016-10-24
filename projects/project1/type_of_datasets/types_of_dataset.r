#1 US egg production R

state_egg_production_1990 <- read.table(header = TRUE, text = "
State Number_of_eggs_produced Price
AL 2206 92.7
AK 0.7 151.0
AZ 73 61.0
AR 3620 86.3
CA 7472 63.4
CO 788 77.8
CT 1029 106.0
DE 168 117
FL 2586 62.0
GA 4302 80.6
HI 227.5 85.0
ID 187 79.1
IL 793 65.0
IN 5445 62.7
IA 2151 56.5
KS 404 54.5
KY 412 67.7
LA 273 115.0
ME 1069 101.0
MD 885 76.6
MA 235 105.0
MI 1406 58.0
MN 2499 57.7
MS 1434 87.8
MO 1580 55.4
MT 172 68.0
NE 1202 50.3
NV 2.2 53.9
NH 43 109.0
NJ 442 85.0
NM 283 74.0
NY 975 68.1
NC 3033 82.8
ND 51 55.2
OH 4667 59.1
OK 869 101.0
OR 652 77.0
PS 4976 61.0
RI 53 102.0
SC 1422 70.1
SD 435 48.0
TN 277 71.0
TX 3317 76.7
UT 456 64.0
VT 31 106.0
VA 843 86.3
WA 1287 74.1
WV 136 104.0
WI 910 60.1
WY 1.7 83.0
")

#Verify your data
dim(state_egg_production_1990)

head(state_egg_production_1990)

#Descriptive statistics
summary(state_egg_production_1990)


#Get documentation on the plot function
?plot

# get your x and y variables
x = state_egg_production_1990$Number_of_eggs_produced
y = state_egg_production_1990$Price

#Open-up a separate plotting window
windows()    #alternatively you can use dev.new()

#Plot the relationship between Quantity of eggs produced and the price
plot(x, y, main="Relationship between number of eggs produced and price, 1990",
     xlab = "Number of eggs produced (millions)",
     ylab = "Price of eggs per dozen (in cents)",
     cex.main=0.8 )


####

# Time series data data

#help on how to read a csv file
?read.table

#read the time series data file
b_101_table = read.table(file="data/b101.csv", header = TRUE, sep=",", stringsAsFactors=FALSE) 


#Verify your data
dim(b_101_table)

#show a section of the file
head(b_101_table[, c(1:5)], n=10)

#What do we have
class(b_101_table)


#convert to time series
#install.packages("zoo")
library(zoo)

#install.packages("xts")
library(xts)


#get the data portion.  That is: exclude column 1
data = apply( b_101_table[, -c(1)], 2, as.numeric )     #very important
dim(data)

#get the data portion.  That is use column 1
date_yq <- as.yearqtr(b_101_table$date, format = "%Y:Q%q")
length(date_yq)

# convert your dataset to a time series data
b_101_table.xts = xts( data, order.by = date_yq )    

#veryfy your data
class(b_101_table.xts)

dim(b_101_table.xts)

head(b_101_table.xts)

names(b_101_table.xts)

# use time series function to display series data
window( round( b_101_table.xts$FL152000005.Q/1000, 1), start="2015Q1", end="2015Q4")

# display a lot more data:
list_of_series = c("FL152000005.Q", "FL152010005.Q", "LM155035005.Q", "LM15503501.Q", "LM165035005.Q")

t( window( round( b_101_table.xts[, list_of_series]/1000, 1), start="2015Q1"))   #note no end date

#--
#get the date part of the time series
index(b_101_table.xts)

#get the data part of the time series
head( coredata(b_101_table.xts) )

#Summary statistics
summary(b_101_table.xts)

#plot selected series
plot.ts(b_101_table.xts$FL152000005.Q/1000, main="time series plot")
grid()

# fix the x axis
mynumtics <- 10                            # 8 tic marks in the x-axis

# ensure the right number of ticmarks
dates = index(b_101_table.xts)
if (  mynumtics > length(index(dates)) ) mynumtics <- length(dates)
mydt = round(seq(1,length(dates), length=mynumtics))
mydt
dates_str <- gsub(" ", "", dates)
dates_str

#--
#direct plot to pdf file
windows()
plot(b_101_table.xts$FL152000005.Q,
        col = "blue",
        main = "time series plot",
        cex.main = .8,
        xaxt = "n",
        xlab = "",
        ylab = "Billions of Dollars",
        cex.lab = .9)
#lines(b_101_table.xts$FL152000005.Q, col = "blue")
#grid()
box()
axis(2)

# create ticks at x values and then label every third tick
axis(side = 1, at = dates[mydt], labels = dates_str[mydt], cex.axis = .9)
#axis(1)
grid()


##
# Logitudiunal Data

tolerance <- read.csv("http://www.ats.ucla.edu/stat/r/examples/alda/data/tolerance1.txt")

dim(tolerance)

head(tolerance, n=10)

summary(tolerance)

# Bivariate correlation among tolerance scores assessed on 4 variables
cor(tolerance[ , 2:5])

pairs(tolerance[ , 2:5])
