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

sData <- cbind(Info[,!grepl("CONTROL|LOCALE|DISTANCEONLY|CITY",names(Info))],VARs)

#Merge
  sData <- merge(sData,poor_students)
  
  #IPEDS
    ipeds.fin <- read.csv("Contest-Data/ipeds/finance.csv",stringsAsFactors=FALSE)
      ipeds.fin <- (mutate(ipeds.fin, Tot_Grant=F1E01+F1E02+F1E05+F1E06))
      sData <- merge(sData,ipeds.fin[,c(1,length(ipeds.fin))])
      
    ipeds.msc <- read.csv("Contest-Data/ipeds/misc.csv",stringsAsFactors=FALSE)
      ipeds.msc <- ipeds.msc[,grepl('NPT41|UNITID',names(ipeds.msc))]
      suppressWarnings( ipeds.msc <- apply(ipeds.msc,2, as.numeric) )
      ipeds.msc <- cbind(ipeds.msc[,1],apply(ipeds.msc[,2:length(names(ipeds.msc))],1,sum))
      colnames(ipeds.msc) <- c("UNITID","Avg_Income_Low")
      sData <- merge(sData,ipeds.msc);
                     
    ipeds.tot <- read.csv("Contest-Data/ipeds/total_students.csv",stringsAsFactors=FALSE)
      names(ipeds.tot) <- c("UNITID","Tot_Students")
      sData <- merge(sData,ipeds.tot)

#Compute Rank
  sData <- mutate(sData, GG_NO_re=(1-gt_25k_p6)-POOR_Prop)
  
#Ensure only needed vars are kept
  sData <- sData[!is.na(sData$GG_NO_re),]
  sData <- sData[!is.na(sData$Avg_Income_Low),]
  sData <- sData[!is.na(sData$Tot_Grant),] 
  sData <- sData[!is.na(sData$Tot_Students),] 
#Filtering
  sData <- filter(sData,CURROPER>0 & RELAFFIL >0) #Omit Inactive unis
  sData <- sData[!apply(sData[,names(Info)[!grepl("CONTROL|LOCALE|DISTANCEONLY|CITY|UNITID|INSTNM|PREDDEG|CURROPER|RELAFFIL",names(Info))]]>0,1,any),];    
  sData <- sData[,!grepl(paste(names(Info)[!grepl("INSTNM|UNITID|PREDDEG",names(Info))],sep='',collapse = '|'),names(sData))]
  sData <- sData[,!grepl("CURROPER|RELAFFIL|HCM2",names(sData))]

#Split by Degree
spD <- split(sData,sData$PREDDEG)  
omitMe <- function(DD,BY=2) apply(DD,BY,function(x) sum(is.na(x))/length(x) ) 

for(name in names(spD)) {  
  spD[[name]] = spD[[name]][,as.logical(omitMe(spD[[name]]) < 0.5)]
  spD[[name]] = spD[[name]][as.logical(omitMe(spD[[name]],1) == 0),]
  write.csv(arrange(spD[[name]][,!grepl("PREDDEG",colnames(spD[[name]]))],desc(GG_NO_re)),paste0('Analyzed-Data/',name,'-cleaned-data.csv'),row.names=FALSE)
}

sData = sData[,as.logical(omitMe(sData) < 0.5)]
sData = sData[as.logical(omitMe(sData,1) == 0),]
write.csv(sData,'Analyzed-Data/Tot-cleaned-data.csv',row.names=FALSE)

