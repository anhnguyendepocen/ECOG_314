# Francisco Brady
# reading in gdp by state, cleaning and transforming
# data from BEA: http://www.bea.gov/regional/downloadzip.cfm
getwd
setwd("~/School/Econ/ECOG 314/Project")
library(dplyr)
gdp_15 <- read.csv(file = "~/School/Econ/ECOG 314/Project/state_gdp_15.csv",
                header = TRUE, sep = ",")
gdp_15 <- mutate(gdp_15, Fips = NULL)
colnames(gdp_15)[colnames(gdp_15)=="Area"] <- "region"
colnames(gdp_15)[colnames(gdp_15)=="X2015"] <- "value"
gdp_15$region <- lapply(gdp_15$region, tolower)
# removing usa row
gdp_15 <- gdp_15[-1,]
gdp_15
# remove regional gdp rows
gdp_15 <- gdp_15[-c(52:64),]
gdp_15$region <- as.character.numeric_version(gdp_15$region)
library(choroplethr)
library(choroplethrMaps)
gdp_15
# make a map of gdp by state
state_choropleth(gdp_15, title = "GDP By State, 2015", legend = "GDP", num_colors = 7,
                 zoom = NULL, reference_map = FALSE)
typeof(gdp_15$region)
state.abb
data(continental_us_states)
