# Francisco Brady
# reading in gdp by state, cleaning and transforming
# data from BEA: http://www.bea.gov/regional/downloadzip.cfm
getwd
setwd("~/School/Econ/ECOG 314/Project")
library(dplyr)
gdp_10 <- read.csv(file = "~/School/Econ/ECOG 314/Project/state_gdp_10.csv",
                header = TRUE, sep = ",")
gdp_10 <- mutate(gdp_10, Fips = NULL)
colnames(gdp_10)[colnames(gdp_10)=="Area"] <- "region"
colnames(gdp_10)[colnames(gdp_10)=="X2010"] <- "value"
gdp_10$region <- lapply(gdp_10$region, tolower)
# removing usa row
gdp_10 <- gdp_10[-1,]
gdp_10
# remove regional gdp rows
gdp_10 <- gdp_10[-c(52:64),]
gdp_10$region <- as.character.numeric_version(gdp_10$region)
library(choroplethr)
library(choroplethrMaps)
gdp_10
# make a map of gdp by state
state_choropleth(gdp_10, title = "GDP By State, 2010", legend = "GDP", num_colors = 7,
                 zoom = NULL, reference_map = FALSE)
typeof(gdp_10$region)
state.abb
data(continental_us_states)
