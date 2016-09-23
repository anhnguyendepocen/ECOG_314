#===============================================================================
#
# This program:
#    1. Reads the clean movies data, 
#    2. Outputs plots to files
#
#===============================================================================

library(ggplot2)

# setwd()

#---------------------
# Import the Raw Data
#---------------------

movies <- read.csv("data/movies.csv", stringsAsFactors = FALSE)

movies$released <- as.Date(movies$released)

movies
str(movies)


#---------------------
# Base R Plots
#---------------------

png("images/movies_plot1.png", width = 600, height = 400)
with(movies,
     
     barplot(revenue, 
             names.arg = title, 
             main = "Movie Revenue")
     
)
dev.off()


png("images/movies_plot2.png", width = 600, height = 400)
with(movies,
     
     barplot(revenue, 
             names.arg = title, 
             horiz = TRUE,
             main = "Movie Revenue")
     
)
dev.off()


png("images/movies_plot3.png", width = 600, height = 400)
with(movies,
     
     plot(released, 
          revenue, 
          type = "l",
          xlab = "Release Date", ylab = "$ Millions",
          main = "Movie Revenue")
     
)
dev.off()

png("images/movies_plot4.png", width = 600, height = 400)
with(movies,
     
     hist(revenue, 
          xlab = "$ Millions",
          main = "Distribution of Movie Revenue")
     
)
dev.off()


#---------------------
# ggplot2 Plots
#---------------------


# bar plot

png("images/movies_plot5.png", width = 600, height = 400)

qplot(x = title, 
      data = movies,
      geom = "bar", 
      weight = revenue,
      xlab = "Movie Title", ylab = "$ Millions",
      main = "Movie Revenue") +
      theme(axis.text.x  = element_text(angle=90, vjust=0.5, hjust = 1, size=12)) 

dev.off()


# horizontal bar plot

png("images/movies_plot6.png", width = 600, height = 400)

qplot(x = title, 
      data = movies,
      geom = "bar", 
      weight = revenue,
      xlab = "Movie Title", ylab = "$ Millions",
      main = "Movie Revenue") + 
    coord_flip()

dev.off()


# sorted horizontal bar plot

png("images/movies_plot7.png", width = 600, height = 400)

qplot(x = reorder(title, -revenue), 
      data = movies,
      geom = "bar", 
      weight = revenue,
      xlab = "Movie Title", ylab = "$ Millions",
      main = "Movie Revenue") + coord_flip()

dev.off()


# line plot

png("images/movies_plot8.png", width = 600, height = 400)

qplot(x = released, 
      y = revenue, 
      data = movies,
      geom = "line", 
      xlab = "Release Date", ylab = "$ Millions",
      main = "Movie Revenue")

dev.off()

# histogram

png("images/movies_plot9.png", width = 600, height = 400)

qplot(x = revenue, 
      data = movies,
      geom = "histogram", 
      binwidth = 100,
      xlab = "Release Date", ylab = "$ Millions",
      main = "Distribution of Movie Revenue")

dev.off()


# cumulative plot (step)

png("images/movies_plot10.png", width = 600, height = 400)

qplot(x = released, 
      y = cumsum(revenue), 
      data = movies,
      geom = "step", 
      xlab = "Release Date", ylab = "$ Millions",
      main = "Cumulative Movie Revenue")

dev.off()

png("images/movies_plot11.png", width = 600, height = 400)
df <- movies
df[is.na(movies$codename), "codename"] <- "other"

qplot(x = codename, 
      data = df,
      geom = "bar", 
      weight = revenue,
      xlab = "Lead Character", ylab = "$ Millions",
      main = "Total Movie Revenue") 

dev.off()