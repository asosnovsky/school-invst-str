rm(list=ls())
require('dplyr')

setwd("C:/Github/school-invst-str/Code")

scardExt <- read.csv("External-Data/MERGED2013_PP.csv",stringsAsFactors=FALSE)


sCP <- (scardExt[,c("INSTNM",
             "NUM4_PUB","NUM4_PRIV","NUM4_PROG","NUM4_OTHER",
             names(scardExt)[grepl("NUM41",names(scardExt))])])


suppressWarnings(
  sCP[,2:length(sCP[1,])] <- apply(sCP[,2:length(sCP[1,])],2,as.numeric)
)
#sCP[is.na(sCP)] = 0


sCP <- (mutate(sCP,
            POOR_Prop_PUB=NUM41_PUB/NUM4_PUB,
            POOR_Prop_PRIV=NUM41_PRIV/NUM4_PRIV,
            POOR_Prop_PROG=NUM41_PUB/NUM4_PROG,
            POOR_Prop_OTHER=NUM41_OTHER/NUM4_OTHER
       )
)

sCP2 <- (sCP[,grepl("POOR_Prop|INSTNM",names(sCP))])
sCP2[is.na(sCP2)] = 0
sCP2[sCP2 == Inf] = 0

sCP2 <- mutate(sCP2, POOR_Prop = POOR_Prop_PUB+POOR_Prop_PRIV+POOR_Prop_PROG+POOR_Prop_OTHER)
sCP3 <- (sCP2[,c("INSTNM","POOR_Prop")])

sCP3$POOR_Prop[sCP3$POOR_Prop <= 0] = NA

write.csv(sCP3,"Analyzed-Data/poor_prop_per_uni.csv")
