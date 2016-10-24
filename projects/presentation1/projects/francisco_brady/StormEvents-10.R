# Francisco Brady
# reading in storm events, cleaning and transforming
# storm events from NOAA NCDC: ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/
getwd
setwd("~/School/Econ/ECOG 314/Project")
# load up some libraries
library(dplyr)
library(stringr)
library(ggplot2)
library(knitr)
library(lubridate)
# reading in first file
ten<- as.data.frame(read.csv("StormEvents/StormEvents_details-ftp_v1.0_d2010_c20160223.csv.gz"))
# getting rid of some columns which aren't useful
ten <- mutate(ten, BEGIN_YEARMONTH = NULL, BEGIN_DAY = NULL, BEGIN_TIME = NULL, 
                END_YEARMONTH = NULL, END_DAY = NULL, END_TIME = NULL, YEAR = NULL, 
                MONTH_NAME = NULL, CZ_TYPE = NULL, CZ_TIMEZONE = NULL, END_DATE_TIME = NULL,
                CATEGORY = NULL, TOR_LENGTH = NULL, TOR_WIDTH = NULL, TOR_OTHER_WFO = NULL,
                TOR_OTHER_CZ_STATE = NULL, TOR_OTHER_CZ_FIPS = NULL, TOR_OTHER_CZ_NAME = NULL,
                BEGIN_RANGE = NULL, BEGIN_AZIMUTH = NULL, BEGIN_LOCATION = NULL, END_RANGE = NULL,
                END_AZIMUTH = NULL, END_LOCATION = NULL, END_LAT = NULL, END_LON = NULL,
                EPISODE_NARRATIVE = NULL, EVENT_NARRATIVE = NULL)
saveRDS(ten, "ten.RDS")
# readRDS("ten.RDS")
# making sure the date is in the right format
ten$BEGIN_DATE_TIME <- as.Date(ten$BEGIN_DATE_TIME, format = "%d-%b-%y")
getNumber <- function(str)
{
  result <- c(0)
  str <- str_trim(str)
  val <- str_sub(str, start=1, end= str_length(str)-1)
  ext <- str_sub(str, start=str_length(str), end = str_length(str) + 1)
  
  ifelse(ext == "K", 
         result <-  as.numeric(val) * 1000,
         (ifelse(ext == "M", result <-  as.numeric(val) * 1000000,result <- as.numeric(str)))
  )
  
  return(ifelse(is.na(result), 0, result))
  
}

options(scipen = 999)
ten$DAMAGE_CROPS <- lapply(ten$DAMAGE_CROPS, getNumber)
ten$DAMAGE_PROPERTY <- lapply(ten$DAMAGE_PROPERTY, getNumber)
# but for now this seems good so far!
# create a single variable for damage
ten$DAMAGE_CROPS <- as.numeric(ten$DAMAGE_CROPS)
ten$DAMAGE_PROPERTY <- as.numeric(ten$DAMAGE_PROPERTY)
# force variables as numeric
ten <- mutate(ten, DAMAGE = DAMAGE_PROPERTY+DAMAGE_CROPS) %>% 
  mutate(DAMAGE_PROPERTY= NULL, DAMAGE_CROPS= NULL)
# combine the direct and indirect injuries variables
ten <- mutate(ten, INJURIES = INJURIES_DIRECT + INJURIES_INDIRECT, 
                INJURIES_DIRECT = NULL, INJURIES_INDIRECT = NULL) 
# combine indirect and direct deaths
typeof(ten$DEATHS_DIRECT)
ten <- mutate(ten, DEATHS = DEATHS_DIRECT + DEATHS_INDIRECT, 
                DEATHS_DIRECT = NULL, DEATHS_INDIRECT = NULL) 
#plot top weather events over time with damage costs
# aggregate events over the year with highest damages
# hints from here: https://rstudio-pubs-static.s3.amazonaws.com/18802_bd84fcf40d744c80986d16374e771293.html
top_events <- ddply(ten, .(ten$EVENT_TYPE, BEGIN_DATE_TIME), 
                    summarize, total = sum(DAMAGE, na.rm = TRUE))

# make a new df for just event costs
ten_cost <- ten[(ten$DAMAGE > 0), c("DAMAGE", "STATE")]
#install.packages("choroplethr")
#install.packages("choroplethrMaps")
library(choroplethr)
library(choroplethrMaps)
# change tolower to match with choroplethr standards
colnames(ten_cost)[colnames(ten_cost)=="STATE"] <- "region"
ten_cost$region <- lapply(ten_cost$region, tolower)
colnames(ten_cost)[colnames(ten_cost)=="DAMAGE"] <- "value"
# sum damages for each state
ten_cost$region <- as.factor(unlist(ten_cost$region))

ten_map <- ten_cost %>% group_by(region) %>%
  summarise_each(funs(sum), value = value)
# make a map of total damages across the states
state_choropleth(ten_map, title = "Total Damages from Storm Events, 2010", legend = "Damages", num_colors = 7,
zoom = NULL, reference_map = FALSE)
# woo! now lets try something with events over time
