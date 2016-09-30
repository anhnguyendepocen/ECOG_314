#===============================================================================
#
# This program:
#    1. Imports the raw avengers roster data, 
#    2. Cleans the data
#    3. Outputs a clean csv file
#
#===============================================================================

#---------------------
# Setup
#---------------------

# setwd()

#---------------------
# Download the Raw Data
#---------------------

#if ( !file.exists("data/raw/avengers.csv") ) download.file()

#---------------------
# Import the Raw Data
#---------------------

avengers <- read.csv("data/raw/avengers.csv", stringsAsFactors = FALSE)

avengers
str(avengers)


#---------------------
# Clean & Transform
#---------------------

# standardize codenames,
# make al lower case

avengers$codename <- tolower(avengers$codename)


#---------------------
# Check the data
#---------------------

avengers
str(avengers)


#---------------------
# Export a new tidy dataset
#---------------------

write.csv(avengers, file = "data/avengers.csv", row.names = FALSE)

