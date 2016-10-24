# Francisco Brady
# reading in gdp by state, cleaning and transforming
# data from BEA: http://www.bea.gov/regional/downloadzip.cfm
getwd
setwd("~/School/Econ/ECOG 314/Project")
library(dplyr)
gdp_11 <- read.csv(file = "~/School/Econ/ECOG 314/Project/state_gdp_11.csv",
                header = TRUE, sep = ",")
gdp_11 <- mutate(gdp_11, Fips = NULL)
colnames(gdp_11)[colnames(gdp_11)=="Area"] <- "region"
colnames(gdp_11)[colnames(gdp_11)=="X2011"] <- "value"
gdp_11$region <- lapply(gdp_11$region, tolower)
# removing usa row
gdp_11 <- gdp_11[-1,]
gdp_11
# remove regional gdp rows
gdp_11 <- gdp_11[-c(52:64),]
gdp_11$region <- as.character.numeric_version(gdp_11$region)
library(choroplethr)
library(choroplethrMaps)
gdp_11
# make a map of gdp by state
state_choropleth(gdp_11, title = "GDP By State, 2011", legend = "GDP", num_colors = 7,
                 zoom = NULL, reference_map = FALSE)
typeof(gdp_11$region)
state.abb
data(continental_us_states)
