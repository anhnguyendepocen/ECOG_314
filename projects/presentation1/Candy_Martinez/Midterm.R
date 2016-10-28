#Candy Martinez
#Midterm Project Script file

library(foreign)
mydata <- read.dta("C:/Users/Owner/Desktop/MoserMartinez/Nigerian panel.dta")
regressiondata <- mydata[!is.na(mydata$female) & !is.na(mydata$logexp) & !is.na(mydata$father_in) & !is.na(mydata$edexpect) & !is.na(mydata$hhsize_PP) & !is.na(mydata$north) & !is.na(mydata$islam) & !is.na(mydata$schooltime) & !is.na(mydata$S12attacks) & !is.na(mydata$logexp),]


#library(ggplot2)
#graph1 <-  ggplot(data= regressiondata) + geom_point(aes(x=elevation, y=edexpect))
#graph1

#summary(regressiondata)
#sapply(mydata, mean, na.rm=TRUE)

library(psych)
sumdata <- describe(mydata)
#write.csv(sumdata, 'sumdata.csv')


df <- data.frame(name= factor(), gender= numeric(), years = numeric() )

#age restricted 
agerestricted <- regressiondata[which(!is.na(regressiondata$agelimit) & 
                                        regressiondata$agelimit==1),]

for (i in unique(agerestricted$Group.1)){
  a = agerestricted[agerestricted$Group.1== i,]
  zero<- a[1,]; one <-a[2,]
  zero_1 = rbind(zero, one)
  df=rbind(df, zero_1)
}
df$Group.1 = paste(df$Group.1, df$Group.2)
rep(levels(agerestricted$Group.1), 2)


colnames(ZONEmeaned) <- c("Zone", "Female", "Years")
library(ggplot2)
graphgender <- ggplot(data = df, aes(x=Group.1, y = x, fill = Group.2) ) +
  geom_bar(stat="identity")+
  coord_flip()+
  ggtitle("Average Expected Education") +
  xlab("Zone")+
  ylab("Years")

windows()
graphgender


# average expected education by gender
Gendermeaned <-aggregate(regressiondata$edexpect, 
                         by = list(regressiondata$female), FUN = "mean")

graph2 <- ggplot(data = Gendermeaned, aes(x=Group.1, y = x) ) +
  geom_bar(stat="identity")+
  ggtitle("Education By Gender") +
  xlab("Gender")+
  ylab("Years")

graph2

#average expected education in each zone
library(ggplot2)
ZONEmeaned <-aggregate(regressiondata$edexpect, by = list(regressiondata$zone, regressiondata$female), FUN = mean)
colnames(ZONEmeaned) <- c("Zone", "Female", "Years")
graph2 <- ggplot(data = ZONEmeaned, aes(x=Zone, y = Years, fill = Female) ) +
          geom_bar(stat="identity")+
          coord_flip()+
          ggtitle("Average Expected Education") +
          xlab("Zone")+
          ylab("Years")

graph2

#Average expected education in each state
Statemeaned <-aggregate(regressiondata$edexpect, by = list(regressiondata$state), FUN = mean)

graph3 <- ggplot(data = Statemeaned, aes(x=Group.1, y = x) ) +
  geom_bar(stat="identity")+
  coord_flip()+
  ggtitle("Average Expected Education") +
  xlab("State")+
  ylab("Years")
graph3

plot(x=regressiondata$elevation, y= regressiondata$S12attacks)

#Elevation & Attacks
library(ggplot2)
graph4 <- ggplot(data = subset(regressiondata, S12attacks<30), aes(x=elevation, y = S12attacks) ) +
  geom_point(position=position_jitter(width = .5, height = .5)) +
  ggtitle("Boko Haram Attacks by States & Elevation") +
  xlab("Elevation (M)")+
  ylab("Boko Haram Attacks")+
  geom_smooth(method=lm,   # Add linear regression line
              se=FALSE)
graph4

graph5 <- ggplot(data = subset(regressiondata, S12attacks<10), aes(x=slope, y = S12attacks) ) +
  geom_point(position=position_jitter(width = .5, height = .5)) +
  ggtitle("Attacks by Slope") +
  xlab("Slope (M)")+
  ylab("Boko Haram Attacks")+
  geom_smooth(method=lm,   # Add linear regression line
              se=FALSE)
graph5

graph6 <- ggplot(data = subset(regressiondata, S12attacks<200), aes(x=northb, y = S12attacks) ) +
  geom_point(position=position_jitter(width = .5, height = .5)) +
  ggtitle("Attacks in Northern regions") +
  xlab("Northern Distance to Borders")+
  ylab("Boko Haram Attacks")+
  geom_smooth(method=lm,   # Add linear regression line
              se=FALSE)
graph6

#########################################################################
#GIS estimation for Nigeria

library(foreign)
geodata <- read.dta("C:/Users/Owner/Desktop/geodata.dta")

library(sp)  # classes for spatial data
library(raster)  # grids, rasters
library(rasterVis)  # raster visualisation
library(maptools)
library(rgeos)


library(dismo)

###Final Process####
#latlon <- CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
NIGERIA <- readShapeSpatial("C:/Users/Owner/Desktop/MoserMartinez/nigeriashp/click2shp_out_line.shp")


for (i in 1:dim(geodata)[1]) {
  lon= geodata$lon_dd_mod[i]
  lat = geodata$lat_dd_mod[i]
  test <- readWKT(paste("POINT(",lon, lat,")", sep=" "))
  geodata$finaldistance[i] <- gDistance(test,NIGERIA)
}
geodata$finaldistancemeters <- 111319* (geodata$finaldistance)
geodata$finaldistanceKM <- 111.32 * (geodata$finaldistance)

write.csv(geodata, "borderdistance.csv")

NIGERIA1 <- readShapeSpatial("C:/Users/Owner/Desktop/MoserMartinez/NGA_adm0.shp")
plot(NIGERIA1)
points(geodata$lon_dd_mod, geodata$lat_dd_mod, col = "red", cex = .6)


NIGERIA2 <- readShapeSpatial("C:/Users/Owner/Desktop/MoserMartinez/NGA_adm1.shp")
points(geodata$lon_dd_mod, geodata$lat_dd_mod, col = "red", cex = .6)


######
#Code came from: http://gis.stackexchange.com/questions/20099/how-to-overlay-map-layers-shp-and-csv-in-r
library(PBSmapping)
northb <- importShapefile("C:/Users/Owner/Desktop/MoserMartinez/nigeriashp/click2shp_out_line.shp")
borders <- importShapefile("C:/Users/Owner/Desktop/MoserMartinez/NGA_adm0.shp")

proj.abbr <- attr(northb, "projection")
proj.full <- attr(borders, "prj")
print(proj.abbr)

plotPolys(borders, projection=proj.abbr, border="gray",
          xlab="Longitude", ylab="Latitude")
points(geodata$lon_dd_mod, geodata$lat_dd_mod, col = "black", cex = .6)
addLines(northb, col="black", lwd=2.0)



#########
#Code came from: http://gis.stackexchange.com/questions/20099/how-to-overlay-map-layers-shp-and-csv-in-r

library(PBSmapping)
northb <- importShapefile("C:/Users/Owner/Desktop/MoserMartinez/nigeriashp/click2shp_out_line.shp")
borders <- importShapefile("C:/Users/Owner/Desktop/MoserMartinez/NGA_adm1.shp")

proj.abbr <- attr(northb, "projection")
proj.full <- attr(borders, "prj")
print(proj.abbr)

plotPolys(borders, projection=proj.abbr, border="gray",
          xlab="Longitude", ylab="Latitude")
points(geodata$lon_dd_mod, geodata$lat_dd_mod, col = "black", cex = .6)
addLines(northb, col="black", lwd=2.0)

  




#########################################################################

fit1 <- lm(regressiondata$edexpect ~ regressiondata$female + regressiondata$hhsize_PP + regressiondata$north + regressiondata$islam + regressiondata$father_in + regressiondata$schooltime + regressiondata$S12attacks + regressiondata$logexp, data=regressiondata)
fit2 <- lm(regressiondata$edexpect ~ regressiondata$female + regressiondata$age, data = regressiondata)
anova(fit1, fit2)

summary(fit1)         
coefficients(fit)
plot(fit)

ivreg(regressiondata$edexpect ~ regressiondata$female + regressiondata$hhsize_PP + regressiondata$north + regressiondata$islam + regressiondata$father_in + regressiondata$schooltime + regressiondata$S12attacks + regressiondata$logexp, data=regressiondata, elevation, data, subset, na.action, weights, offset,
      contrasts = NULL, model = TRUE, y = TRUE, x = FALSE, ...)

