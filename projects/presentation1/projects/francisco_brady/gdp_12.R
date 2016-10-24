# Francisco Brady
# reading in gdp by state, cleaning and transforming
# data from BEA: http://www.bea.gov/regional/downloadzip.cfm
getwd
setwd("~/School/Econ/ECOG 314/Project")
library(dplyr)
gdp_12 <- read.csv(file = "~/School/Econ/ECOG 314/Project/state_gdp_12.csv",
                header = TRUE, sep = ",")
gdp_12 <- mutate(gdp_12, Fips = NULL)
colnames(gdp_12)[colnames(gdp_12)=="Area"] <- "region"
colnames(gdp_12)[colnames(gdp_12)=="X2012"] <- "value"
gdp_12$region <- lapply(gdp_12$region, tolower)
# removing usa row
gdp_12 <- gdp_12[-1,]
gdp_12
# remove regional gdp rows
gdp_12 <- gdp_12[-c(52:64),]
gdp_12$region <- as.character.numeric_version(gdp_12$region)
library(choroplethr)
library(choroplethrMaps)
gdp_12
# make a map of gdp by state
state_choropleth(gdp_12, title = "GDP By State, 2012", legend = "GDP", num_colors = 7,
                 zoom = NULL, reference_map = FALSE)
typeof(gdp_12$region)
state.abb
data(continental_us_states)
