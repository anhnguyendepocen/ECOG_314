#===============================================================================
#
# This program:
#    1. Reads the clean screen time data, 
#    2. Outputs plots to files
#
#===============================================================================

library(ggplot2)

# setwd()

#---------------------
# Import the Raw Data
#---------------------

screen_time <- read.csv("data/screen_time.csv", stringsAsFactors = FALSE)

head(screen_time, 25)
str(screen_time)


#---------------------
# Base R Plots
#---------------------

png("images/screen_time_plot1.png", width = 600, height = 400)
with(screen_time,
     
     hist(minutes, 
          xlab = "Minutes",
          main = "Distribution of Screen Time")
     
)
dev.off()


png("images/screen_time_plot2.png", width = 600, height = 400)
with(screen_time,
     
     boxplot(minutes ~ is_avenger, 
             names = c("Others", "Avengers Members"),
             ylab = "Minutes",
             main = "Distribution of Screen Time")
     
)
dev.off()


png("images/screen_time_plot3.png", width = 600, height = 400)

# Aggregate time on screen for avengers
df <- with(subset(screen_time, screen_time$is_avenger == 1),
           
           aggregate(minutes, by = list(codename), FUN = "sum")
           
)
names(df) <- c("codename", "minutes")

barplot(df$minutes,
        names.arg = df$codename, 
        ylab = "Minutes",
        main = "Total Screen Time")
  
dev.off()


#---------------------
# ggplot2 Plots
#---------------------

png("images/screen_time_plot4.png", width = 600, height = 400)

qplot(x = codename,
      data = subset(screen_time, screen_time$is_avenger == 1),
      geom = "bar", 
      weight = minutes,
      xlab = "Avenger", ylab = "Minutes",
      main = "Total Screen Time")

dev.off()
