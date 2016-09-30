#===============================================================================
#
# This program:
#    1. Imports the raw movie data, 
#    2. Cleans the data
#    3. Outputs a clean csv file
#
#===============================================================================

#---------------------
# Setup
#---------------------

# Check working directory,
# Reset if neccessary

getwd()
setwd(".")


#---------------------
# Import the Raw Data
#---------------------

movies <- read.delim("data/raw/movies.txt", sep = "|", stringsAsFactors = FALSE)

movies
str(movies)


#---------------------
# Clean & Transform
#---------------------

#--- Revenue ---#

# remove commas and dollar signs
# from the revenue variable

movies[, "revenue"] <- gsub('[$,]', '', movies$revenue)


# convert text to numeric,
# and change units to millions

movies[, "revenue"] <- as.integer(movies$revenue) / 1000000


#--- Dates ---#

# convert text into dates

movies[, "released"] <- as.Date(movies$released, format = "%B %d, %Y")


#--- Title ---#

# standardize title spelling

movies[, "title"] <- gsub("^Marvel's ", "", movies$title)

# standardize title capitalization

movies[, "title"] <- tolower(movies$title)                             

#--- Determine the main character by movie title ---#

movies[, "codename"] <- as.character(NA)  # create an empty variable

# subset the data frame for opbservations with titles that match
# then assign a value to the hero codename variable
movies[grepl("black widow",     movies$title), "codename"] <- "black widow"
movies[grepl("captain america", movies$title), "codename"] <- "captain america"
movies[grepl("hawkeye",         movies$title), "codename"] <- "hawkeye"
movies[grepl("hulk",            movies$title), "codename"] <- "hulk"
movies[grepl("iron man",        movies$title), "codename"] <- "iron man"
movies[grepl("thor",            movies$title), "codename"] <- "thor"


#---------------------
# Check the data
#---------------------

subset(movies, movies$codename %in% c("thor", "captain america"))

str(movies)


#---------------------
# Export tidy dataset
#---------------------

write.csv(movies, file = "data/movies.csv", row.names = FALSE)


