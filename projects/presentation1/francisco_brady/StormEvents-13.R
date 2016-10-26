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
thirteen<- as.data.frame(read.csv("StormEvents/StormEvents_details-ftp_v1.0_d2013_c20160223.csv.gz"))
thirteen <- mutate(thirteen, BEGIN_YEARMONTH = NULL, BEGIN_DAY = NULL, BEGIN_TIME = NULL, 
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
thirteen$DAMAGE_CROPS <- lapply(thirteen$DAMAGE_CROPS, getNumber)
thirteen$DAMAGE_PROPERTY <- lapply(thirteen$DAMAGE_PROPERTY, getNumber)
# but for now this seems good so far!
# create a single variable for damage
thirteen$DAMAGE_CROPS <- as.numeric(thirteen$DAMAGE_CROPS)
thirteen$DAMAGE_PROPERTY <- as.numeric(thirteen$DAMAGE_PROPERTY)
# force variables as numeric
thirteen <- mutate(thirteen, DAMAGE = DAMAGE_PROPERTY+DAMAGE_CROPS) %>% 
  mutate(DAMAGE_PROPERTY= NULL, DAMAGE_CROPS= NULL)
# combine the direct and indirect injuries variables
thirteen <- mutate(thirteen, INJURIES = INJURIES_DIRECT + INJURIES_INDIRECT, 
                INJURIES_DIRECT = NULL, INJURIES_INDIRECT = NULL) 
# combine indirect and direct deaths
typeof(thirteen$DEATHS_DIRECT)
thirteen <- mutate(thirteen, DEATHS = DEATHS_DIRECT + DEATHS_INDIRECT, 
                DEATHS_DIRECT = NULL, DEATHS_INDIRECT = NULL) 
# make a new df for just event costs
thirteen_cost <- thirteen[(thirteen$DAMAGE > 0), c("DAMAGE", "STATE")]
#install.packages("choroplethr")
#install.packages("choroplethrMaps")
library(choroplethr)
library(choroplethrMaps)
# change tolower to match with choroplethr standards
colnames(thirteen_cost)[colnames(thirteen_cost)=="STATE"] <- "region"
thirteen_cost$region <- lapply(thirteen_cost$region, tolower)
colnames(thirteen_cost)[colnames(thirteen_cost)=="DAMAGE"] <- "value"
# sum damages for each state
thirteen_cost$region <- as.factor(unlist(thirteen_cost$region))

thirteen_map <- thirteen_cost %>% group_by(region) %>%
  summarise_each(funs(sum), value = value)
# make a map of total damages across the states
state_choropleth(thirteen_map, title = "Total Damages from Storm Events, 2013", legend = "Damages", num_colors = 7,
zoom = NULL, reference_map = FALSE)
