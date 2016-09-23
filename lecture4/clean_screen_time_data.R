#===============================================================================
#
# This program:
#    1. Imports the raw screen time data, 
#    2. Cleans the data
#    3. Outputs a clean csv file
#
#===============================================================================

#---------------------
# Setup
#---------------------

# setwd()

#---------------------
# Import the Raw Data
#---------------------

screen_time <- read.delim("data/raw/screen_time.txt", sep = "\t", header = FALSE, stringsAsFactors = FALSE)

head(screen_time, 25)
str(screen_time)


#---------------------
# Clean & Transform
#---------------------

#--- Assign variable names ---#

names(screen_time) <- c("name", "info")



#--- Create a movie title variable ---#

screen_time[, "title"] <- gsub("\\* ", "", screen_time$info)         # remove literal "*" from start of info text
screen_time[, "title"] <- gsub(" <.*", "", screen_time$title)        # remove everything after " <"
screen_time[, "title"] <- gsub(" \\(cameo.*", "", screen_time$title) # remove "cameo" from title
screen_time[, "title"] <- tolower(screen_time$title)


#--- Create a screen time variable ---#

# create a new character variable
# with time in <minutes:seconds> format
screen_time[, "time"]    <- gsub(".*<|>.*", "", screen_time$info)                   # remove text before "<" or after ">"

# get the minutes only
screen_time$minutes <- as.integer(gsub(":.*", "", screen_time$time) )               # remove text after ":"
screen_time$minutes <- ifelse(is.na(screen_time$minutes), 0,  screen_time$minutes)  # replace NA with zero

# get the seconds only
screen_time$seconds <- as.integer(gsub(".*:", "", screen_time$time) )              # remove text before ":", convert to numeric
screen_time$seconds <- ifelse(is.na(screen_time$seconds), 0,  screen_time$seconds) # replace missing with zero

# total time (in minutes)
screen_time[, "minutes"] <- screen_time$minutes + (screen_time$seconds / 60)


#--- Create an indicator for cameo appearances ---#

screen_time[, "cameo"] <- grepl("cameo", screen_time$info)    # True or false, the text contains "cameo"?
screen_time[, "cameo"] <- as.integer(screen_time$cameo)       # convert indicator to 0/1 flag variable

#--- Standardize Name  ---#
                             
#(lower case all)
screen_time[, "name"] <- tolower(screen_time$name)

#--- Translate name to codename  ---#

# first assume the name is the codename
screen_time[, "codename"] <- screen_time$name                                              
                             
# Then replace known aliases
screen_time[, "codename"] <- gsub('tony stark', 'iron man', screen_time$codename)          
screen_time[, "codename"] <- gsub('bruce banner', 'hulk', screen_time$codename)
screen_time[, "codename"] <- gsub('natasha romanoff', 'black widow', screen_time$codename)
screen_time[, "codename"] <- gsub('clint barton', 'hawkeye', screen_time$codename)

#--- Create an indicator for Avengers members ---#

the_avengers <- c('black widow', 
                  'captain america',
                  'hawkeye',
                  'hulk',
                  'iron man',
                 'thor')

screen_time[, "is_avenger"] <- ifelse(screen_time$codename %in% the_avengers, 1, 0)

# Drop extra variables from data frame
screen_time$info <- NULL
screen_time$time <- NULL
screen_time$seconds <- NULL


                             
#---------------------
# Check the data
#---------------------
                             
head(screen_time, 25)
str(screen_time)


#---------------------
# Export a new tidy dataset
#---------------------

write.csv(screen_time, file = "data/screen_time.csv", row.names = FALSE)

