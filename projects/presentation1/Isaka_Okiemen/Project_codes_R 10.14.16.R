rm(list=ls())
setwd("C:/Users/Phdecon/Desktop/ECOG_314_term_project")

hh2013 <- read.table(
  file = "csv_2013/hh2013_analys.csv",
  #
  header = TRUE, # filehas a header
  sep = ",", # rows separated by commas
  
)
class(hh2013)
#dummy for bank status
hh2013$unbanked <- ifelse(hh2013$hbankstatv3==1,1,0)
hh2013$bankedunder <- ifelse(hh2013$hbankstatv3==2,1,0)
hh2013$bankedfull <- ifelse(hh2013$hbankstatv3==3,1,0)

#dummy for payday loan use in last 12 months
hh2013$payday <- ifelse(hh2013$huse2pdl==1,1,0)

##dummy for no high-rate credit
hh2013$nohighrate <- ifelse(hh2013$hanyafsv3==4,1,0)

#dumm for household never used payday loan
hh2013$nopayday <- ifelse(hh2013$huse2pdl==3,1,0)

#dummy for pawnshop use for last 12 months
hh2013$pawnshop <- ifelse(hh2013$huse2pwn==1,1,0)

#dummy for household never used pawnshop loan
hh2013$nopawnshop <- ifelse(hh2013$huse2pwn==3,1,0)

#dummy for prepaidcard use for last 12 months
hh2013$prepaidcard <- ifelse(hh2013$huse2pp==1,1,0)

#dummy for home ownership status
hh2013$homeowner <- ifelse(hh2013$hhtenure==1,1,0)

#dummy for household income
hh2013$income <- ifelse(hh2013$hhincome==2,1,0)
hh2013$income1 <- ifelse(hh2013$hhincome==1,1,0) #income less than $15,000
hh2013$income2 <- ifelse(hh2013$hhincome==2,1,0) #income between $15,000 and $30,000
hh2013$income3 <- ifelse(hh2013$hhincome==3,1,0) #income between $30,000 and $50,000
hh2013$income4 <- ifelse(hh2013$hhincome==4,1,0) #income between $50,000 and $75,000
hh2013$income5 <- ifelse(hh2013$hhincome==5,1,0) # income greater than $75,000




#dummy for household age group
hh2013$age25.34 <- ifelse(hh2013$pagegrp==2,1,0)  #age group between 25 and 35
hh2013$age15.24 <- ifelse(hh2013$pagegrp==1,1,0)  #age group between 15 and 24
hh2013$age35.44 <- ifelse(hh2013$pagegrp==3,1,0)  #age group between 35 and 44
hh2013$age45.54 <- ifelse(hh2013$pagegrp==4,1,0)  #age group between 45 and 54
hh2013$age55.64 <- ifelse(hh2013$pagegrp==5,1,0)  #age group between 55 and 64
hh2013$age65more <- ifelse(hh2013$pagegrp==6,1,0) #age group 65 or more


#dummy for education level(no high school degree)
hh2013$educ1 <- ifelse(hh2013$peducgrp==1,1,0)

#dummy for education level(high school and college degree)
hh2013$educ2 <- ifelse(hh2013$peducgrp==2,1,0) #high school
hh2013$educ3 <- ifelse(hh2013$peducgrp==4,1,0) #college college
hh2013$educ4 <- ifelse(hh2013$peducgrp==3,1,0) 
#some college degree

#dummy for employment status (employed)
hh2013$emp <- ifelse(hh2013$pempstat==1,1,0)

#dummy variable for race/ethnicity       

hh2013$black <- ifelse(hh2013$praceeth==1,1,0)
hh2013$hispanic <- ifelse(hh2013$praceeth==2,1,0)
hh2013$white <- ifelse(hh2013$praceeth==6,1,0)

#dummy for refund anticipation loan used in last 12 months
hh2013$ral <- ifelse(hh2013$huse2ral==1,1,0)

#dummy for household who never used refund anticipation loan
hh2013$noral <- ifelse(hh2013$huse2ral==3,1,0)

#dummy for rent-to-own used last 12 months
hh2013$rentto <- ifelse(hh2013$huse2rto==1,1,0)

#dummy for household who never used rent-to-own
hh2013$norentto <- ifelse(hh2013$huse2rto==3,1,0)

#dummy for autotitle loan used last 12 months
hh2013$autoti <- ifelse(hh2013$huse2atl==1,1,0)

#dummy for household never used autotitle loan 
hh2013$noautoti <- ifelse(hh2013$huse2atl==3,1,0)

#dummy for unmarried female-headed household
hh2013$femalehh <- ifelse(hh2013$hhtype==2,1,0)

#dummy for MSA
hh2013$MSA_Detroit <- ifelse(hh2013$gtcbsa==19820,1,0)
hh2013$MSA_DMV <- ifelse(hh2013$gtcbsa==47900,1,0)
hh2013$MSA_NY.NJ <- ifelse(hh2013$gtcbsa==35620,1,0)
hh2013$MSA_DE <- ifelse(hh2013$gtcbsa==20100,1,0)
hh2013$MSA_PA <- ifelse(hh2013$gtcbsa==25420,1,0)
hh2013$MSA_VA <- ifelse(hh2013$gtcbsa==40060,1,0)
hh2013$MSA_OH <- ifelse(hh2013$gtcbsa==47900,1,0)

#dummy for states
hh2013$DC <- ifelse(hh2013$gestfips==11,1,0)
hh2013$DE <- ifelse(hh2013$gestfips==10,1,0)
hh2013$MD <- ifelse(hh2013$gestfips==24,1,0)
hh2013$PA <- ifelse(hh2013$gestfips==42,1,0)
hh2013$NY <- ifelse(hh2013$gestfips==36,1,0)

#new dataframe for households who used credit produts
usepayday <-hh2013[hh2013$payday==1,]
usepawn <-hh2013[hh2013$pawnshop==1,]
userentto <-hh2013[hh2013$rentto==1,]
useautoti <-hh2013[hh2013$autoti==1,]
useral <-hh2013[hh2013$ral==1,]
nohighrate <-hh2013[hh2013$nohighrate==1,]


#create new vector
usepaydaymean <-c(mean(usepayday$femalehh),mean(usepayday$homeowner),mean(usepayday$income1),
                  mean(usepayday$income2),mean(usepayday$income3),mean(usepayday$income4),
                  mean(usepayday$income5),mean(usepayday$age15.24),mean(usepayday$age25.34),
                  mean(usepayday$age35.44),mean(usepayday$age45.54),mean(usepayday$age55.64),
                  mean(usepayday$age65more),mean(usepayday$educ1),mean(usepayday$educ2),mean(usepayday$educ3),
                  mean(usepayday$educ4),
                  mean(usepayday$emp),mean(usepayday$black),mean(usepayday$hispanic),mean(usepayday$unbanked),
                  mean(usepayday$white))

##no high-rate credit
nohighratemean <-c(mean(nohighrate$femalehh),mean(nohighrate$homeowner),mean(nohighrate$income1),
                   mean(nohighrate$income2),mean(nohighrate$income3),mean(nohighrate$income4),
                   mean(nohighrate$income5),mean(nohighrate$age15.24),mean(nohighrate$age25.34),
                   mean(nohighrate$age35.44),mean(nohighrate$age45.54),mean(nohighrate$age55.64),
                   mean(nohighrate$age65more),mean(nohighrate$educ1),mean(nohighrate$educ2),
                   mean(nohighrate$educ3),mean(nohighrate$educ4),
                   mean(nohighrate$emp),mean(nohighrate$black),mean(nohighrate$hispanic),mean(nohighrate$unbanked),
                   mean(nohighrate$white))

usepawnmean <-c(mean(usepawn$femalehh),mean(usepawn$homeowner),mean(usepawn$income1),
                mean(usepawn$income2),mean(usepawn$income3),mean(usepawn$income4),
                mean(usepawn$income5),mean(usepawn$age15.24),mean(usepawn$age25.34),
                mean(usepawn$age35.44),mean(usepawn$age45.54),mean(usepawn$age55.64),
                mean(usepawn$age65more),mean(usepawn$educ1),mean(usepawn$educ2),
                mean(usepawn$educ3),mean(usepawn$educ4),
                mean(usepawn$emp),mean(usepawn$black),mean(usepawn$hispanic),mean(usepawn$unbanked),
                mean(usepawn$white))

userenttomean <-c(mean(userentto$femalehh),mean(userentto$homeowner),mean(userentto$income1),
                  mean(userentto$income2),mean(userentto$income3),mean(userentto$income4),
                  mean(userentto$income5),mean(userentto$age15.24),mean(userentto$age25.34),
                  mean(userentto$age35.44),mean(userentto$age45.54),mean(userentto$age55.64),
                  mean(userentto$age65more),mean(userentto$educ1),mean(userentto$educ2),mean(userentto$educ3),
                  mean(userentto$educ4),
                  mean(userentto$emp),mean(userentto$black),mean(userentto$hispanic),mean(userentto$unbanked),
                  mean(userentto$white))

useautotimean <-c(mean(useautoti$femalehh),mean(useautoti$homeowner),mean(useautoti$income1),
                  mean(useautoti$income2),mean(useautoti$income3),mean(useautoti$income4),
                  mean(useautoti$income5),mean(useautoti$age15.24),mean(useautoti$age25.34),
                  mean(useautoti$age35.44),mean(useautoti$age45.54),mean(useautoti$age55.64),
                  mean(useautoti$age65more),mean(useautoti$educ1),mean(useautoti$educ2),mean(useautoti$educ3),
                  mean(useautoti$educ4),
                  mean(useautoti$emp),mean(useautoti$black),mean(useautoti$hispanic),mean(useautoti$unbanked),
                  mean(useautoti$white))

useralmean <-c(mean(useral$femalehh),mean(useral$homeowner),mean(useral$income1),
               mean(useral$income2),mean(useral$income3),mean(useral$income4),
               mean(useral$income5),mean(useral$age15.24),mean(useral$age25.34),
               mean(useral$age35.44),mean(useral$age45.54),mean(useral$age55.64),
               mean(useral$age65more),mean(useral$educ1),mean(useral$educ2),mean(useral$educ3),mean(useral$educ4),
               mean(useral$emp),mean(useral$black),mean(useral$hispanic),mean(useral$unbanked),mean(useral$white))


#create column
meantable <-data.frame(usepaydaymean,usepawnmean,userenttomean,useautotimean,useralmean,nohighratemean)
rownames(meantable)<-c("femalehh","homeowner","income1","income2","income3","income4","income5",
                       "age15.24","age25.34","age35.44","age45.54","age55.64","age65more","edu1","edu2","edu3",
                       "edu4",
                       "emp","black","hispanic","unbanked","white")
write.csv(meantable,"C:/Users/Phdecon/Desktop/ECOG_314_term_project/tables/tables.csv")


#new dataframe for never use credit products
neverpayday <-hh2013[hh2013$nopayday==1,]
neverpawn <-hh2013[hh2013$nopawnshop==1,]
neverrentto <-hh2013[hh2013$norentto==1,]
neverautoti <-hh2013[hh2013$noautoti==1,]
neverral <-hh2013[hh2013$noral==1,]


#create new vector for never use credit products

neverpaydaymean <-c(mean(neverpayday$femalehh),mean(neverpayday$homeowner),mean(neverpayday$income1),
                    mean(neverpayday$income2),mean(neverpayday$income3),mean(neverpayday$income4),
                    mean(neverpayday$income5),mean(neverpayday$age15.24),mean(neverpayday$age25.34),
                    mean(neverpayday$age35.44),mean(neverpayday$age45.54),mean(neverpayday$age55.64),
                    mean(neverpayday$age65more),mean(neverpayday$educ1),mean(neverpayday$educ2),mean(neverpayday$educ3),
                    mean(neverpayday$emp),mean(neverpayday$black),mean(neverpayday$hispanic),mean(neverpayday$unbanked),
                    mean(neverpayday$white))


neverpawnmean <-c(mean(neverpawn$femalehh),mean(neverpawn$homeowner),mean(neverpawn$income1),
                  mean(neverpawn$income2),mean(neverpawn$income3),mean(neverpawn$income4),
                  mean(neverpawn$income5),mean(neverpawn$age15.24),mean(neverpawn$age25.34),
                  mean(neverpawn$age35.44),mean(neverpawn$age45.54),mean(neverpawn$age55.64),
                  mean(neverpawn$age65more),mean(neverpawn$educ1),mean(neverpawn$educ2),mean(neverpawn$educ3),
                  mean(neverpawn$emp),mean(neverpawn$black),mean(neverpawn$hispanic),mean(neverpawn$unbanked),
                  mean(neverpawn$white))

neverrenttomean <-c(mean(neverrentto$femalehh),mean(neverrentto$homeowner),mean(neverrentto$income1),
                    mean(neverrentto$income2),mean(neverrentto$income3),mean(neverrentto$income4),
                    mean(neverrentto$income5),mean(neverrentto$age15.24),mean(neverrentto$age25.34),
                    mean(neverrentto$age35.44),mean(neverrentto$age45.54),mean(neverrentto$age55.64),
                    mean(neverrentto$age65more),mean(neverrentto$educ1),mean(neverrentto$educ2),mean(neverrentto$educ3),
                    mean(neverrentto$emp),mean(neverrentto$black),mean(neverrentto$hispanic),mean(neverrentto$unbanked),
                    mean(neverrentto$white))

neverautotimean <-c(mean(neverautoti$femalehh),mean(neverautoti$homeowner),mean(neverautoti$income1),
                    mean(neverautoti$income2),mean(neverautoti$income3),mean(neverautoti$income4),
                    mean(neverautoti$income5),mean(neverautoti$age15.24),mean(neverautoti$age25.34),
                    mean(neverautoti$age35.44),mean(neverautoti$age45.54),mean(neverautoti$age55.64),
                    mean(neverautoti$age65more),mean(neverautoti$educ1),mean(neverautoti$educ2),mean(neverautoti$educ3),
                    mean(neverautoti$emp),mean(neverautoti$black),mean(neverautoti$hispanic),mean(neverautoti$unbanked),
                    mean(neverautoti$white))

neverralmean <-c(mean(neverral$femalehh),mean(neverral$homeowner),mean(neverral$income1),
                 mean(neverral$income2),mean(neverral$income3),mean(neverral$income4),
                 mean(neverral$income5),mean(neverral$age15.24),mean(neverral$age25.34),
                 mean(neverral$age35.44),mean(neverral$age45.54),mean(neverral$age55.64),
                 mean(neverral$age65more),mean(neverral$educ1),mean(neverral$educ2),mean(neverral$educ3),
                 mean(neverral$emp),mean(neverral$black),mean(neverral$hispanic),mean(neverral$unbanked),
                 mean(neverral$white))


#create column
meantable1 <-data.frame(neverpaydaymean,neverpawnmean,neverrenttomean,neverautotimean,neverralmean)
rownames(meantable1)<-c("femalehh","homeowner","income1","income2","income3","income4","income5",
                        "age15.24","age25.34","age35.44","age45.54","age55.64","age65more","edu1","edu2","edu3",
                        "emp","black","hispanic","unbanked","white")
write.csv(meantable1,"C:/Users/Phdecon/Desktop/ECOG_314_term_project/tables1.csv")


#new dataframe for households who used credit produts
paydayMSA_DMV <-hh2013[hh2013$payday==1&hh2013$MSA_DMV==1,]
pawnshopMSA_DMV <-hh2013[hh2013$pawnshop==1&hh2013$MSA_DMV==1,]
renttoMSA_DMV <-hh2013[hh2013$rentto==1&hh2013$MSA_DMV==1,]
autotiMSA_DMV <-hh2013[hh2013$autoti==1&hh2013$MSA_DMV==1,]
ralMSA_DMV <-hh2013[hh2013$ral==1&hh2013$MSA_DMV==1,]
nohighrateMSA_DMV <-hh2013[hh2013$nohighrate==1&hh2013$MSA_DMV==1,]

#create new vector
paydayMSA_DMVmean <-c(mean(paydayMSA_DMV$femalehh),mean(paydayMSA_DMV$homeowner),mean(paydayMSA_DMV$income1),
                      mean(paydayMSA_DMV$income2),mean(paydayMSA_DMV$income3),mean(paydayMSA_DMV$income4),
                      mean(paydayMSA_DMV$income5),mean(paydayMSA_DMV$age15.24),mean(paydayMSA_DMV$age25.34),
                      mean(paydayMSA_DMV$age35.44),mean(paydayMSA_DMV$age45.54),mean(paydayMSA_DMV$age55.64),
                      mean(paydayMSA_DMV$age65more),mean(paydayMSA_DMV$educ1),mean(paydayMSA_DMV$educ2),mean(paydayMSA_DMV$educ3),
                      mean(paydayMSA_DMV$emp),mean(paydayMSA_DMV$black),mean(paydayMSA_DMV$hispanic),mean(paydayMSA_DMV$unbanked),
                      mean(paydayMSA_DMV$white))

nohighrateMSA_DMVmean <-c(mean(nohighrateMSA_DMV$femalehh),mean(nohighrateMSA_DMV$homeowner),mean(nohighrateMSA_DMV$income1),
                          mean(nohighrateMSA_DMV$income2),mean(nohighrateMSA_DMV$income3),mean(nohighrateMSA_DMV$income4),
                          mean(nohighrateMSA_DMV$income5),mean(nohighrateMSA_DMV$age15.24),mean(nohighrateMSA_DMV$age25.34),
                          mean(nohighrateMSA_DMV$age35.44),mean(nohighrateMSA_DMV$age45.54),mean(nohighrateMSA_DMV$age55.64),
                          mean(nohighrateMSA_DMV$age65more),mean(nohighrateMSA_DMV$educ1),mean(nohighrateMSA_DMV$educ2),mean(nohighrateMSA_DMV$educ3),
                          mean(nohighrateMSA_DMV$emp),mean(nohighrateMSA_DMV$black),mean(nohighrateMSA_DMV$hispanic),mean(nohighrateMSA_DMV$unbanked),
                          mean(nohighrateMSA_DMV$white))

pawnshopMSA_DMVmean <-c(mean(pawnshopMSA_DMV$femalehh),mean(pawnshopMSA_DMV$homeowner),mean(pawnshopMSA_DMV$income1),
                        mean(pawnshopMSA_DMV$income2),mean(pawnshopMSA_DMV$income3),mean(pawnshopMSA_DMV$income4),
                        mean(pawnshopMSA_DMV$income5),mean(pawnshopMSA_DMV$age15.24),mean(pawnshopMSA_DMV$age25.34),
                        mean(pawnshopMSA_DMV$age35.44),mean(pawnshopMSA_DMV$age45.54),mean(pawnshopMSA_DMV$age55.64),
                        mean(pawnshopMSA_DMV$age65more),mean(pawnshopMSA_DMV$educ1),mean(pawnshopMSA_DMV$educ2),mean(pawnshopMSA_DMV$educ3),
                        mean(pawnshopMSA_DMV$emp),mean(pawnshopMSA_DMV$black),mean(pawnshopMSA_DMV$hispanic),mean(pawnshopMSA_DMV$unbanked),
                        mean(pawnshopMSA_DMV$white))

renttoMSA_DMVmean <-c(mean(renttoMSA_DMV$femalehh),mean(renttoMSA_DMV$homeowner),mean(renttoMSA_DMV$income1),
                      mean(renttoMSA_DMV$income2),mean(renttoMSA_DMV$income3),mean(renttoMSA_DMV$income4),
                      mean(renttoMSA_DMV$income5),mean(renttoMSA_DMV$age15.24),mean(renttoMSA_DMV$age25.34),
                      mean(renttoMSA_DMV$age35.44),mean(renttoMSA_DMV$age45.54),mean(renttoMSA_DMV$age55.64),
                      mean(renttoMSA_DMV$age65more),mean(renttoMSA_DMV$educ1),mean(renttoMSA_DMV$educ2),mean(renttoMSA_DMV$educ3),
                      mean(renttoMSA_DMV$emp),mean(renttoMSA_DMV$black),mean(renttoMSA_DMV$hispanic),mean(renttoMSA_DMV$unbanked),
                      mean(renttoMSA_DMV$white))

autotiMSA_DMVmean <-c(mean(autotiMSA_DMV$femalehh),mean(autotiMSA_DMV$homeowner),mean(autotiMSA_DMV$income1),
                      mean(autotiMSA_DMV$income2),mean(autotiMSA_DMV$income3),mean(autotiMSA_DMV$income4),
                      mean(autotiMSA_DMV$income5),mean(autotiMSA_DMV$age15.24),mean(autotiMSA_DMV$age25.34),
                      mean(autotiMSA_DMV$age35.44),mean(autotiMSA_DMV$age45.54),mean(autotiMSA_DMV$age55.64),
                      mean(autotiMSA_DMV$age65more),mean(autotiMSA_DMV$educ1),mean(autotiMSA_DMV$educ2),mean(autotiMSA_DMV$educ3),
                      mean(autotiMSA_DMV$emp),mean(autotiMSA_DMV$black),mean(autotiMSA_DMV$hispanic),mean(autotiMSA_DMV$unbanked),
                      mean(autotiMSA_DMV$white))

ralMSA_DMVmean <-c(mean(ralMSA_DMV$femalehh),mean(ralMSA_DMV$homeowner),mean(ralMSA_DMV$income1),
                   mean(ralMSA_DMV$income2),mean(ralMSA_DMV$income3),mean(ralMSA_DMV$income4),
                   mean(ralMSA_DMV$income5),mean(ralMSA_DMV$age15.24),mean(ralMSA_DMV$age25.34),
                   mean(ralMSA_DMV$age35.44),mean(ralMSA_DMV$age45.54),mean(ralMSA_DMV$age55.64),
                   mean(ralMSA_DMV$age65more),mean(ralMSA_DMV$educ1),mean(ralMSA_DMV$educ2),mean(ralMSA_DMV$educ3),
                   mean(ralMSA_DMV$emp),mean(ralMSA_DMV$black),mean(ralMSA_DMV$hispanic),mean(ralMSA_DMV$unbanked),
                   mean(ralMSA_DMV$white))


#create column
meantable3 <-data.frame(paydayMSA_DMVmean,pawnshopMSA_DMVmean,renttoMSA_DMVmean,autotiMSA_DMVmean,ralMSA_DMVmean,nohighrateMSA_DMVmean)

rownames(meantable3)<-c("femalehh","homeowner","income1","income2","income3","income4","income5",
                        "age15.24","age25.34","age35.44","age45.54","age55.64","age65more","edu1","edu2","edu3",
                        "emp","black","hispanic","unbanked","white")

write.csv(meantable3,"C:/Users/Phdecon/Desktop/ECOG_314_term_project/tables/tables2.csv")



#new dataframe for households who nevercredit produts
neverpaydayMSA_DMV <-hh2013[hh2013$nopayday==1&hh2013$MSA_DMV==1,]
neverpawnshopMSA_DMV <-hh2013[hh2013$nopawnshop==1&hh2013$MSA_DMV==1,]
neverrenttoMSA_DMV <-hh2013[hh2013$norentto==1&hh2013$MSA_DMV==1,]
neverautotiMSA_DMV <-hh2013[hh2013$noautoti==1&hh2013$MSA_DMV==1,]
neverralMSA_DMV <-hh2013[hh2013$noral==1&hh2013$MSA_DMV==1,]

#create new vector
neverpaydayMSA_DMVmean <-c(mean(neverpaydayMSA_DMV$femalehh),mean(neverpaydayMSA_DMV$homeowner),mean(neverpaydayMSA_DMV$income1),
                           mean(neverpaydayMSA_DMV$income2),mean(neverpaydayMSA_DMV$income3),mean(neverpaydayMSA_DMV$income4),
                           mean(neverpaydayMSA_DMV$income5),mean(neverpaydayMSA_DMV$age15.24),mean(neverpaydayMSA_DMV$age25.34),
                           mean(neverpaydayMSA_DMV$age35.44),mean(neverpaydayMSA_DMV$age45.54),mean(neverpaydayMSA_DMV$age55.64),
                           mean(neverpaydayMSA_DMV$age65more),mean(neverpaydayMSA_DMV$educ1),mean(neverpaydayMSA_DMV$educ2),mean(neverpaydayMSA_DMV$educ3),
                           mean(neverpaydayMSA_DMV$emp),mean(neverpaydayMSA_DMV$black),mean(neverpaydayMSA_DMV$hispanic),mean(neverpaydayMSA_DMV$unbanked),
                           mean(neverpaydayMSA_DMV$white))

neverpawnshopMSA_DMVmean <-c(mean(neverpawnshopMSA_DMV$femalehh),mean(neverpawnshopMSA_DMV$homeowner),mean(neverpawnshopMSA_DMV$income1),
                             mean(neverpawnshopMSA_DMV$income2),mean(neverpawnshopMSA_DMV$income3),mean(neverpawnshopMSA_DMV$income4),
                             mean(neverpawnshopMSA_DMV$income5),mean(neverpawnshopMSA_DMV$age15.24),mean(neverpawnshopMSA_DMV$age25.34),
                             mean(neverpawnshopMSA_DMV$age35.44),mean(neverpawnshopMSA_DMV$age45.54),mean(neverpawnshopMSA_DMV$age55.64),
                             mean(neverpawnshopMSA_DMV$age65more),mean(neverpawnshopMSA_DMV$educ1),mean(neverpawnshopMSA_DMV$educ2),mean(neverpawnshopMSA_DMV$educ3),
                             mean(neverpawnshopMSA_DMV$emp),mean(neverpawnshopMSA_DMV$black),mean(neverpawnshopMSA_DMV$hispanic),mean(neverpawnshopMSA_DMV$unbanked),
                             mean(neverpawnshopMSA_DMV$white))

neverrenttoMSA_DMVmean <-c(mean(neverrenttoMSA_DMV$femalehh),mean(neverrenttoMSA_DMV$homeowner),mean(neverrenttoMSA_DMV$income1),
                           mean(neverrenttoMSA_DMV$income2),mean(neverrenttoMSA_DMV$income3),mean(neverrenttoMSA_DMV$income4),
                           mean(neverrenttoMSA_DMV$income5),mean(neverrenttoMSA_DMV$age15.24),mean(neverrenttoMSA_DMV$age25.34),
                           mean(neverrenttoMSA_DMV$age35.44),mean(neverrenttoMSA_DMV$age45.54),mean(neverrenttoMSA_DMV$age55.64),
                           mean(neverrenttoMSA_DMV$age65more),mean(neverrenttoMSA_DMV$educ1),mean(neverrenttoMSA_DMV$educ2),mean(neverrenttoMSA_DMV$educ3),
                           mean(neverrenttoMSA_DMV$emp),mean(neverrenttoMSA_DMV$black),mean(neverrenttoMSA_DMV$hispanic),mean(neverrenttoMSA_DMV$unbanked),
                           mean(neverrenttoMSA_DMV$white))

neverautotiMSA_DMVmean <-c(mean(neverautotiMSA_DMV$femalehh),mean(neverautotiMSA_DMV$homeowner),mean(neverautotiMSA_DMV$income1),
                           mean(neverautotiMSA_DMV$income2),mean(neverautotiMSA_DMV$income3),mean(neverautotiMSA_DMV$income4),
                           mean(neverautotiMSA_DMV$income5),mean(neverautotiMSA_DMV$age15.24),mean(neverautotiMSA_DMV$age25.34),
                           mean(neverautotiMSA_DMV$age35.44),mean(neverautotiMSA_DMV$age45.54),mean(neverautotiMSA_DMV$age55.64),
                           mean(neverautotiMSA_DMV$age65more),mean(neverautotiMSA_DMV$educ1),mean(neverautotiMSA_DMV$educ2),mean(neverautotiMSA_DMV$educ3),
                           mean(neverautotiMSA_DMV$emp),mean(neverautotiMSA_DMV$black),mean(neverautotiMSA_DMV$hispanic),mean(neverautotiMSA_DMV$unbanked),
                           mean(neverautotiMSA_DMV$white))

neverralMSA_DMVmean <-c(mean(neverralMSA_DMV$femalehh),mean(neverralMSA_DMV$homeowner),mean(neverralMSA_DMV$income1),
                        mean(neverralMSA_DMV$income2),mean(neverralMSA_DMV$income3),mean(neverralMSA_DMV$income4),
                        mean(neverralMSA_DMV$income5),mean(neverralMSA_DMV$age15.24),mean(neverralMSA_DMV$age25.34),
                        mean(neverralMSA_DMV$age35.44),mean(neverralMSA_DMV$age45.54),mean(neverralMSA_DMV$age55.64),
                        mean(neverralMSA_DMV$age65more),mean(neverralMSA_DMV$educ1),mean(neverralMSA_DMV$educ2),mean(neverralMSA_DMV$educ3),
                        mean(neverralMSA_DMV$emp),mean(neverralMSA_DMV$black),mean(neverralMSA_DMV$hispanic),mean(neverralMSA_DMV$unbanked),
                        mean(neverralMSA_DMV$white))


#create column
meantable4 <-data.frame(neverpaydayMSA_DMVmean,neverpawnshopMSA_DMVmean,neverrenttoMSA_DMVmean,neverautotiMSA_DMVmean,neverralMSA_DMVmean)

rownames(meantable4)<-c("femalehh","homeowner","income1","income2","income3","income4","income5",
                        "age15.24","age25.34","age35.44","age45.54","age55.64","age65more","edu1","edu2","edu3",
                        "emp","black","hispanic","unbanked","white")

write.csv(meantable4,"C:/Users/Phdecon/Desktop/ECOG_314_term_project/tables/tables3.csv")


##plot
library(ggplot2)
ggplot(hh2013,aes(x=payday,y=income5))+ geom_point()+geom_smooth(method=glm)


head(hh2013[,c("payday","income4","income5")])
   
##Emperical model[logit mothodology]

mylogit1 <-glm(payday ~ femalehh +unbanked+ homeowner+ age25.34+age15.24+age35.44+income1+
                 income2+income3+income4 +age15.24+age25.34
               +age35.44+age45.54+age55.64+ black+hispanic, data=hh2013,family = "binomial")

#wald test for mylogit1
library(survey)
regTermTest(mylogit1, "femalehh")

##create a matrix plot of scatterplots
## 
pairs(~income1+income2+income3+income4 +educ1 +educ2 +educ3, data = hh2013,
      main = "corr between independent variables")


library(ggplot2)  

###


## put histograms on the diagonal
panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}

## put (absolute) correlations on the upper panels,
## with size proportional to the correlations.
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
pairs(hh2013[1:100,1:6], lower.panel = panel.smooth, upper.panel = panel.cor)




library(caret)
install.packages("e1071")
library(e1071)
train <- createDataPartition(hh2013$payday,p=0.6,list=FALSE)
training <- hh2013[train,]
testing <- hh2013[-train,]

mylogit1 <-train(factor(payday) ~ femalehh +unbanked+ homeowner+ age25.34+age15.24+age35.44+income1+
                 income2+income3+income4 +age15.24+age25.34
               +age35.44+age45.54+age55.64+ black+hispanic, data=training,method="glm",family = "binomial")

pred=predict(mylogit1,newdata = testing,type = "prob")
install.packages("pscl")
library(pscl)
##Pseudo Test
pR2(mylogit1)
##Wald Test
library(survey)
regTermTest(mylogit1, "femalehh")

summary(mylogit1) 

testdata <- hh2013[,c("payday","femalehh","unbanked","homeowner","age25.34","age15.24","age35.44","income1",
                      "income2","income3","income4","age15.24","age25.34",
                    "age35.44","age45.54","age55.64","black","hispanic")]

## Testing model accuracy
##line 388 is the same as line 398

#pred = predict(mylogit1, newdata=hh2013,type="prob")
accuracy <- table(pred, testdata[,"payday"])
sum(diag(accuracy))/sum(accuracy)


mylogit2 <-glm(pawnshop ~ femalehh+ unbanked+ homeowner +age25.34+age15.24+age35.44+income1+
                 income2+income3+income4 +age15.24+age25.34
               +age35.44+age45.54+age55.64+ black+ hispanic, data=hh2013,family = "binomial")

#wald test for mylogit2
regTermTest(mylogit2, "unbanked")

summary(mylogit2)

pred = predict(mylogit2, newdata=hh2013,type="prob")
accuracy <- table(pred, testdata[,"payday"])
sum(diag(accuracy))/sum(accuracy)

mylogit3 <-glm(autoti ~ femalehh+ unbanked+ homeowner +age25.34+age15.24+age35.44+income1+
                 income2+income3+income4 +age15.24+age25.34
               +age35.44+age45.54+age55.64+ black+ hispanic, data=hh2013,family = "binomial")

##wald test for mylogit3

regTermTest(mylogit3, "age45.54")
summary(mylogit3)

##mylogit4

mylogit4 <-glm(nohighrate ~ femalehh +unbanked+ homeowner+ age25.34+age15.24+age35.44+income1+
                 income2+income3+income4 +age15.24+age25.34
               +age35.44+age45.54+age55.64+ black+hispanic, data=hh2013,family = "binomial")

regTermTest(mylogit4, "age45.54")
summary(mylogit4)

##Household 2013 for MSA_DMV only 10.14.16
MSA_DMV <- subset(hh2013,hh2013$MSA_DMV==47900)

##test1. Another approch to determining the goodness of fit is through the Homer-Lemeshow statistics, which is computed on data after the observations have been segmented into groups based on having similar predicted probabilities. It examines whether the observed proportions of events are similar to the predicted probabilities of occurence in subgroups of the data set using a pearson chi square test. Small values with large p-values indicate a good fit to the data while large values with p-values below 0.05 indicate a poor fit. The null hypothesis holds that the model fits the data and in the below example we would reject H0
#install.packages("ResourceSelection")
library(ResourceSelection)
hoslem.test(hh2013$autoti, fitted(mylogit1))

##test2
install.packages("lmtest")
library(lmtest)

##compare two models

lrtest(mylogit1,mylogit2)

##Variable Importance. To assess the relative importance of individual predictors in the model, 
#we can also look at the absolute value of the t-statistic for each model parameter. 
#This technique is utilized by the varImp function in the caret package for general and generalized linear models.

#install.packages("caret")
library(caret)

varImp(mylogit1)

##Test3. Wald test. A wald test is used to evaluate the statistical significance of each coefficient in the model and is calculated 
#by taking the ratio of the square of the regression coefficient to the square of the standard error of the coefficient. 
#The idea is to test the hypothesis that the coefficient of an independent variable in the model is significantly different from zero. 
#If the test fails to reject the null hypothesis, this suggests that removing the variable from the model will not substantially harm the fit of that model.
#install.packages("survey")
library(survey)
regTermTest(mylogit2, "femalehh")
