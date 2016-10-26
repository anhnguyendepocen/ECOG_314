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
fourteen<- as.data.frame(read.csv("StormEvents/StormEvents_details-ftp_v1.0_d2014_c20160617.csv.gz"))
fourteen <- mutate(fourteen, BEGIN_YEARMONTH = NULL, BEGIN_DAY = NULL, BEGIN_TIME = NULL, 
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
fourteen$DAMAGE_CROPS <- lapply(fourteen$DAMAGE_CROPS, getNumber)
fourteen$DAMAGE_PROPERTY <- lapply(fourteen$DAMAGE_PROPERTY, getNumber)
# but for now this seems good so far!
# create a single variable for damage
fourteen$DAMAGE_CROPS <- as.numeric(fourteen$DAMAGE_CROPS)
fourteen$DAMAGE_PROPERTY <- as.numeric(fourteen$DAMAGE_PROPERTY)
# force variables as numeric
fourteen <- mutate(fourteen, DAMAGE = DAMAGE_PROPERTY+DAMAGE_CROPS) %>% 
  mutate(DAMAGE_PROPERTY= NULL, DAMAGE_CROPS= NULL)
# combine the direct and indirect injuries variables
fourteen <- mutate(fourteen, INJURIES = INJURIES_DIRECT + INJURIES_INDIRECT, 
                INJURIES_DIRECT = NULL, INJURIES_INDIRECT = NULL) 
# combine indirect and direct deaths
typeof(fourteen$DEATHS_DIRECT)
fourteen <- mutate(fourteen, DEATHS = DEATHS_DIRECT + DEATHS_INDIRECT, 
                DEATHS_DIRECT = NULL, DEATHS_INDIRECT = NULL) 
# make a new df for just event costs
fourteen_cost <- fourteen[(fourteen$DAMAGE > 0), c("DAMAGE", "STATE")]
#install.packages("choroplethr")
#install.packages("choroplethrMaps")
library(choroplethr)
library(choroplethrMaps)
# change tolower to match with choroplethr standards
colnames(fourteen_cost)[colnames(fourteen_cost)=="STATE"] <- "region"
fourteen_cost$region <- lapply(fourteen_cost$region, tolower)
colnames(fourteen_cost)[colnames(fourteen_cost)=="DAMAGE"] <- "value"
# sum damages for each state
fourteen_cost$region <- as.factor(unlist(fourteen_cost$region))

fourteen_map <- fourteen_cost %>% group_by(region) %>%
  summarise_each(funs(sum), value = value)
# make a map of total damages across the states
state_choropleth(fourteen_map, title = "Total Damages from Storm Events, 2014", legend = "Damages", num_colors = 7,
zoom = NULL, reference_map = FALSE)
sort(unique(fourteen$EVENT_TYPE))
