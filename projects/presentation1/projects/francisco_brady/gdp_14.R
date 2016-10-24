# Francisco Brady
# reading in gdp by state, cleaning and transforming
# data from BEA: http://www.bea.gov/regional/downloadzip.cfm
getwd
setwd("~/School/Econ/ECOG 314/Project")
library(dplyr)
gdp_14 <- read.csv(file = "~/School/Econ/ECOG 314/Project/state_gdp_14.csv",
                header = TRUE, sep = ",")
gdp_14 <- mutate(gdp_14, Fips = NULL)
colnames(gdp_14)[colnames(gdp_14)=="Area"] <- "region"
colnames(gdp_14)[colnames(gdp_14)=="X2014"] <- "value"
gdp_14$region <- lapply(gdp_14$region, tolower)
# removing usa row
gdp_14 <- gdp_14[-1,]
gdp_14
# remove regional gdp rows
gdp_14 <- gdp_14[-c(52:64),]
gdp_14$region <- as.character.numeric_version(gdp_14$region)
library(choroplethr)
library(choroplethrMaps)
gdp_14
# make a map of gdp by state
state_choropleth(gdp_14, title = "GDP By State, 2014", legend = "GDP", num_colors = 7,
                 zoom = NULL, reference_map = FALSE)
typeof(gdp_14$region)
state.abb
data(continental_us_states)
