rm(list=ls())
require('dplyr')

setwd("C:/Github/school-invst-str/Code")

top10 <- list()
for(data in dir("Analyzed-Data/")[grepl("(cleaned-data-top10)",dir("Analyzed-Data/"))]){
  tmp0 <- read.csv(paste0("Analyzed-Data/",data),stringsAsFactors = FALSE);
  tmp0 <- mutate(tmp0, IP=POOR_Prop, OP=1-gt_25k_p6, 
                Tui=Avg_Income_Low, phi=Tot_Students, 
                GR=Tot_Grant, R=GG_NO_re)
  tmp0 <- tmp0[,length(tmp0[1,])-(5:0)]
  top10[[gsub('-cleaned-data-top10.csv','',data)]] <- mutate(tmp0,delta=1/(phi*(IP-OP)*Tui))
  
  #GC
  rm(tmp0)
  rm(data)
}

orig <- list()
for(data in dir("Analyzed-Data/")[grepl('cleaned-data.csv',dir("Analyzed-Data/"))]){
  name <- gsub('-cleaned-data.csv','',data);
  if(name=='Tot'){
    name <- "4"
  }
  orig[[name]] <- read.csv(paste0('Analyzed-Data/',data),stringsAsFactors = FALSE)
  rm(data)
  rm(name)
}

chosen <- list()
for(data in dir("Analyzed-Data/")[grepl("-cleaned-data-chosen.csv",dir("Analyzed-Data/"))]){
  name <- gsub('-cleaned-data-chosen.csv','',data);
  tmp0 <- read.csv(paste0("Analyzed-Data/",data),stringsAsFactors = FALSE);
  
  cls = c()
  for(scID in 1:length(tmp0[,1])){
    school = tmp0[scID,]
    tmp1 = orig[[name]][which(orig[[name]][,2] == school$Name),]
    tmp1 <- mutate(tmp1, IP=POOR_Prop, OP=1-gt_25k_p6, 
                   Tui=Avg_Income_Low, phi=Tot_Students, 
                   GR=Tot_Grant, R=GG_NO_re)
    
    Uo <- top10[[name]][school$Class+1,]
    go <- Uo$GR/Uo$phi
    tmp1 <- mutate(tmp1, delta=1/(phi*Tui*(IP-OP)),g=go-GR/phi)
    cls=rbind(cls,cbind(tmp0[scID,][,c('Name','Class')],tmp1[,c('g','delta')]))
  }
  chosen[[name]] = cls;
  write.csv(cls,paste0('Matlab-Ready-Data/',name,'.csv'))
  rm(list=c("Uo","go","tmp1","cls","school","name","tmp0","data","scID"))
}


