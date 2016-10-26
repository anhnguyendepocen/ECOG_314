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
# reading in first file
eleven<- as.data.frame(read.csv("StormEvents/StormEvents_details-ftp_v1.0_d2011_c20160223.csv.gz"))
eleven <- mutate(eleven, BEGIN_YEARMONTH = NULL, BEGIN_DAY = NULL, BEGIN_TIME = NULL, 
                END_YEARMONTH = NULL, END_DAY = NULL, END_TIME = NULL, YEAR = NULL, 
                MONTH_NAME = NULL, CZ_TYPE = NULL, CZ_TIMEZONE = NULL, END_DATE_TIME = NULL,
                CATEGORY = NULL, TOR_LENGTH = NULL, TOR_WIDTH = NULL, TOR_OTHER_WFO = NULL,
                TOR_OTHER_CZ_STATE = NULL, TOR_OTHER_CZ_FIPS = NULL, TOR_OTHER_CZ_NAME = NULL,
                BEGIN_RANGE = NULL, BEGIN_AZIMUTH = NULL, BEGIN_LOCATION = NULL, END_RANGE = NULL,
                END_AZIMUTH = NULL, END_LOCATION = NULL, END_LAT = NULL, END_LON = NULL,
                EPISODE_NARRATIVE = NULL, EVENT_NARRATIVE = NULL)
# getting rid of some columns which aren't useful
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
eleven$DAMAGE_CROPS <- lapply(eleven$DAMAGE_CROPS, getNumber)
eleven$DAMAGE_PROPERTY <- lapply(eleven$DAMAGE_PROPERTY, getNumber)
# but for now this seems good so far!
# create a single variable for damage
eleven$DAMAGE_CROPS <- as.numeric(eleven$DAMAGE_CROPS)
eleven$DAMAGE_PROPERTY <- as.numeric(eleven$DAMAGE_PROPERTY)
# force variables as numeric
eleven <- mutate(eleven, DAMAGE = DAMAGE_PROPERTY+DAMAGE_CROPS) %>% 
  mutate(DAMAGE_PROPERTY= NULL, DAMAGE_CROPS= NULL)
# combine the direct and indirect injuries variables
eleven <- mutate(eleven, INJURIES = INJURIES_DIRECT + INJURIES_INDIRECT, 
                INJURIES_DIRECT = NULL, INJURIES_INDIRECT = NULL) 
# combine indirect and direct deaths
typeof(eleven$DEATHS_DIRECT)
eleven <- mutate(eleven, DEATHS = DEATHS_DIRECT + DEATHS_INDIRECT, 
                DEATHS_DIRECT = NULL, DEATHS_INDIRECT = NULL) 
# make a new df for just event costs
eleven_cost <- eleven[(eleven$DAMAGE > 0), c("DAMAGE", "STATE")]
#install.packages("choroplethr")
#install.packages("choroplethrMaps")
library(choroplethr)
library(choroplethrMaps)
# change tolower to match with choroplethr standards
colnames(eleven_cost)[colnames(eleven_cost)=="STATE"] <- "region"
eleven_cost$region <- lapply(eleven_cost$region, tolower)
colnames(eleven_cost)[colnames(eleven_cost)=="DAMAGE"] <- "value"
# sum damages for each state
eleven_cost$region <- as.factor(unlist(eleven_cost$region))

eleven_map <- eleven_cost %>% group_by(region) %>%
  summarise_each(funs(sum), value = value)
# make a map of total damages across the states
state_choropleth(eleven_map, title = "Total Damages from Storm Events, 2011", legend = "Damages", num_colors = 7,
zoom = NULL, reference_map = FALSE)
