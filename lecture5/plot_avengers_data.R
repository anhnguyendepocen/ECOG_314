#===============================================================================
#
# This program:
#    1. Reads the clean avengers roster data, 
#    2. Outputs plots to files
#
#===============================================================================

library(ggplot2)

# setwd()

#---------------------
# Import the Raw Data
#---------------------

avengers <- read.csv("data/avengers.csv", stringsAsFactors = FALSE)

avengers
str(avengers)


#---------------------
# Base R Plots
#---------------------


png("images/avengers_plot1.png", width = 600, height = 400)
with(avengers,
     
     barplot(movies, 
             names.arg = codename, 
             main = "Movie Count for each Avengers Member")
     
)
dev.off()


png("images/avengers_plot2.png", width = 600, height = 400)
with(avengers,
     
     hist(movies, 
          main = "Distribution of Movie Count for Avengers Members")
     
)
dev.off()



#---------------------
# Using ggplot2 package
#---------------------

# Refer to http://docs.ggplot2.org/dev/vignettes/qplot.html


png("images/avengers_plot3.png", width = 600, height = 400)

qplot(codename, 
      data = avengers, 
      geom = "bar", 
      weight = movies, 
      main = "Movie Count for each Avengers Member")

dev.off()


png("images/avengers_plot4.png", width = 600, height = 400)

qplot(movies, 
      data = avengers, 
      geom = "histogram", 
      binwidth = 1, 
      main = "Distribution of Movie Count for Avengers Members")

dev.off()