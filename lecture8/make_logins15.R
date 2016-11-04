#setwd("~/Projects/ECOG_314/lecture8")
library(rjson)
library(purrr)
#library(devtools)
#install_github("theoldfather/KaggleR")
library(KaggleR)
library(lubridate)
logins<-read_file("data/logins.json") %>% fromJSON() %>% adf()
# variable definitions
logins<- logins %>% 
  mutate( dt = ymd_hms(login_time),
          d = date(dt),
          month = month(dt),
          week = week(dt),
          yday = yday(dt),
          wday = lubridate::wday(dt,label=TRUE),
          h12 = format(dt,format="%I") %>% an(),
          h = hour(dt),
          m = minute(dt),
          m15 = 15*floor(m/15),
          dt15 = ymd_hm(sprintf("%d-%02d-%02d %d:%d",year(dt),month(dt),day(dt),h,m15)),
          h.m = h+m15/60,
          h12.m = h12+m15/60,
          log = 1,
          weather = 1*(d >= date("1970-03-16") & d<=date("1970-03-16") + 7 )
  )
# expand to including missing intervals
scaffold<-logins %>% select(d,month,week,yday,wday) %>% 
  distinct(d,month,week,yday,wday) %>% 
  group_by(d,month,week,yday,wday) %>% 
  do(data.frame(h.m=seq(0,23.75,.25),h12.m=c(seq(12,12.75,.25),seq(1,11.75,.25)))) 
# fill column values for missing invervals
# then drop observations at beginning and end which were missing and should not be not in the sample
logins<-left_join(scaffold,logins) %>%  
  mutate(log=fill.na(log,0),
         weather=1*( d >= date("1970-03-16") & d <= date("1970-03-16") + 7 ),
         m15=(h.m-floor(h.m))*60,
         h=floor(h.m),
         h12=floor(h12.m),
         dt15=ymd_hm(sprintf("%d-%02d-%02d %02d:%02d",year(d),month(d),day(d),h,m15))
  ) %>%
  filter(dt15<ymd_hm("1970-04-13 19:00"),dt15>ymd_hm("1970-01-01 19:59"))
# label holidays
map_holidays<-function(d){
  h<-c("New Year's"=date("1970-01-01"),
       "Orth. Xmas"=date("1970-01-07"),
       "MLK Day"=date("1970-01-19"),
       "Val. Day"=date("1970-02-14"),
       "Pres. Day"=date("1970-02-16"),
       "Women's Day"=date("1970-03-08")
  )
  map_chr(d,function(x) ifelse(x %in% h,names(h)[which(h==x)],"None"))
}
holiday_labels<-logins %>% group_by(d) %>% summarise(holiday=unique(d) %>% map_holidays())
logins<-left_join(logins,holiday_labels,by="d")
# aggregate to 15 minute intervals
logins15<-logins %>% 
  group_by(d,week,yday,wday,h12,h,m15,dt15,h.m,h12.m,holiday) %>% 
  summarise(log=sum(log)) %>% ungroup() %>% arrange(dt15)
save(logins15,file="data/logins15.Rdata")