# Francisco Brady
# reading in gdp by state, cleaning and transforming
# data from BEA: http://www.bea.gov/regional/downloadzip.cfm
getwd
setwd("~/School/Econ/ECOG 314/Project")
library(dplyr)
gdp_13 <- read.csv(file = "~/School/Econ/ECOG 314/Project/state_gdp_13.csv",
                header = TRUE, sep = ",")
gdp_13 <- mutate(gdp_13, Fips = NULL)
colnames(gdp_13)[colnames(gdp_13)=="Area"] <- "region"
colnames(gdp_13)[colnames(gdp_13)=="X2013"] <- "value"
gdp_13$region <- lapply(gdp_13$region, tolower)
# removing usa row
gdp_13 <- gdp_13[-1,]
gdp_13
# remove regional gdp rows
gdp_13 <- gdp_13[-c(52:64),]
gdp_13$region <- as.character.numeric_version(gdp_13$region)
library(choroplethr)
library(choroplethrMaps)
gdp_13
# make a map of gdp by state
state_choropleth(gdp_13, title = "GDP By State, 2013", legend = "GDP", num_colors = 7,
                 zoom = NULL, reference_map = FALSE)
typeof(gdp_13$region)
state.abb
data(continental_us_states)
