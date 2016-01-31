rm(list=ls())
require('dplyr')

setwd("C:/Github/school-invst-str/Code")

top10 <- list()
for(data in dir("Analyzed-Data/benchmarks")){
  name <- gsub('-cleaned-data-top10.csv','',data);
  if(name=='4'){
    name <- "tot"
  }
  tmp0 <- read.csv(paste0("Analyzed-Data/benchmarks/",data),stringsAsFactors = FALSE);
  tmp0 <- mutate(tmp0, IP=POOR_Prop, OP=1-gt_25k_p6, 
                Tui=Avg_Income_Low, phi=Tot_Students, 
                GR=Tot_Grant, R=GG_NO_re)
  tmp0 <- tmp0[,length(tmp0[1,])-(5:0)]
  top10[[name]] <- mutate(tmp0,delta=1/(phi*(IP-OP)*Tui))
  
  #GC
  rm(tmp0)
  rm(name)
  rm(data)
}

orig <- list()
for(data in dir("Analyzed-Data/filtered/")[grepl('cleaned-data.csv',dir("Analyzed-Data/filtered/"))]){
  name <- gsub('-cleaned-data.csv','',data);
  if(name=='Tot'){
    name <- "tot"
  }
  orig[[name]] <- read.csv(paste0('Analyzed-Data/filtered/',data),stringsAsFactors = FALSE)
  rm(data)
  rm(name)
}

chosen <- c()
for(data in dir("Analyzed-Data/knn_chosen/")){
  name <- gsub('-cleaned-data-chosen.csv','',data);
  tmp0 <- read.csv(paste0("Analyzed-Data/knn_chosen/",data),stringsAsFactors = FALSE);
  
  cls = c()
  for(scID in 1:length(tmp0[,1])){
    school = tmp0[scID,]
    tmp1 = orig[[name]][which(orig[[name]][,2] == gsub('\\[|\\]|\'','',school$Name)),]
    tmp1 <- mutate(tmp1, IP=POOR_Prop, OP=1-gt_25k_p6, 
                   Tui=Avg_Income_Low, phi=Tot_Students, 
                   GR=Tot_Grant, R=GG_NO_re)
    
    Uo <- top10[[name]][school$Class+1,]
    go <- Uo$GR/Uo$phi
    suppressWarnings(
      tmp1 <- mutate(tmp1, delta=1/(phi*Tui*(IP-OP)),g=go-GR/phi,
                     UNAME= paste(INSTNM,' (',UNITID,')'))
    )
    
    cls=rbind(cls,
     cbind(
      tmp1[,c('UNAME','g','delta','phi')])
    )
    
  }
  if(name != "tot") {
    chosen = rbind(chosen, cls[!is.na(cls[,3]),])
  } else {
    chosen <- mutate(chosen, ID = 1:length(UNAME))
    cls <- mutate(cls[!is.na(cls[,3]),], ID = 1:length(UNAME))
    
    write.csv(apply(chosen[,2:5],2,as.numeric),
              "Matlab-Ready-Data/parted.data.csv",
              row.names = FALSE)
    write.csv(chosen[,c("ID","UNAME")],
              "Matlab-Ready-Data/parted.name.csv",
              row.names = FALSE)
    write.csv(apply(cls[,2:5],2,as.numeric),
              "Matlab-Ready-Data/full.data.csv",
              row.names = FALSE)
    write.csv(cls[,c("ID","UNAME")],
              "Matlab-Ready-Data/full.name.csv",
              row.names = FALSE)
  }
  #write.csv(apply(cls[,2:5],2,as.numeric),
  #          paste0('Matlab-Ready-Data/',name,'.data.csv'),
  #          row.names = FALSE)
  #write.csv(cls[,c("ID","Name")],
  #          paste0('Matlab-Ready-Data/',name,'.names.csv'),
  #          row.names = FALSE)
  rm(list=c("Uo","go","tmp1","school","name","tmp0","data","scID"))
}


