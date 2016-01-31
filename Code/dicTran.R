rm(list=ls())
require('dplyr')

setwd("C:\Github\school-invst-str\Code")

dic <- read.csv("Contest-Data/CollegeScorecardDataDictionary.csv")
vars <- read.csv("collegescorecard_data.csv")

cdic  <- (select(dic,VARIABLE.NAME,NAME.OF.DATA.ELEMENT))
cdic <- apply(cdic,2,as.character)
vname <- names(vars)

                      rm(list=c("dic","vars"))

t=c();
for (name in vname){
  t = rbind(t, as.character(cdic[grepl(name,cdic[,1]),]))  
}

write.csv(t,"Analyzed-Data/NEW-DIC.csv",row.names=FALSE,col.names = FALSE)
