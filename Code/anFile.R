rm(list=ls())
require('dplyr')

setwd("C:/Github/school-invst-str/Code")

#Rating	Type
#0	None
#1	Informaive
#2	Variable
#3	Prcentile

dic   <- (read.csv("Analyzed-Data/NEW-DIC-AN.csv",stringsAsFactors=FALSE)[,c(1,3)])
scard <- read.csv( "Contest-Data/collegescorecard_data.csv",stringsAsFactors=FALSE)
poor_students <- read.csv("Analyzed-Data/poor_prop_per_uni.csv")[,2:3]

Info = ((scard[,dic[dic[,2]==1,1]])) 
VARs = ((scard[,dic[dic[,2]==2,1]])) 
  ( suppressWarnings(VARs <- apply(VARs,2,as.numeric)) )
Prec = ((scard[,dic[dic[,2]==3,1]])) 
  ( suppressWarnings(Prec <- apply(Prec,2,as.numeric)) )

  
sData <- cbind(Info[,c("INSTNM","PREDDEG","CURROPER")],VARs)
sData <- merge(sData,poor_students)

  sData <- filter(sData,CURROPER>0) #Omit Inactive unis
  
write.csv('')
