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
#c("INSTNM","PREDDEG","CURROPER")

sData <- cbind(Info[,!grepl("CONTROL|LOCALE|DISTANCEONLY|CITY",names(Info))],VARs)

#Merge
  sData <- merge(sData,poor_students)

#Filtering
  sData <- filter(sData,CURROPER>0 & RELAFFIL >0) #Omit Inactive unis
  sData <- sData[!apply(sData[,names(Info)[!grepl("CONTROL|LOCALE|DISTANCEONLY|CITY|UNITID|INSTNM|PREDDEG|CURROPER|RELAFFIL",names(Info))]]>0,1,any),];    
  sData <- sData[,!grepl(paste(names(Info)[!grepl("INSTNM|UNITID|PREDDEG",names(Info))],sep='',collapse = '|'),names(sData))]
  sData <- sData[,!grepl("CURROPER|RELAFFIL|HCM2",names(sData))]

#Split by Degree
spD <- split(sData,sData$PREDDEG)  
omitMe <- function(DD,BY=2) apply(DD,BY,function(x) sum(is.na(x))/length(x) ) 

for(name in names(spD)) {  
  spD[[name]] = spD[[name]][,!grepl("PREDDEG",colnames(spD[[name]]))]
  spD[[name]] = spD[[name]][,as.logical(omitMe(spD[[name]]) < 0.5)]
  spD[[name]] = spD[[name]][as.logical(omitMe(spD[[name]],1) == 0),]
  write.csv(spD[[name]],paste0('Analyzed-Data/',name,'-cleaned-data.csv'),row.names=FALSE)
}

write.csv(sData,'Analyzed-Data/pre-cleaned-data.csv',row.names=FALSE)

