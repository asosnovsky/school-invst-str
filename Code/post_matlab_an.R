rm(list=ls())
require('dplyr')

setwd("C:/Github/school-invst-str/Code")

partData <- read.csv("Maximized-Data/partitioned.csv");
colnames(partData) = c("ID", "n", "A", "r")
partName <- read.csv("Matlab-Ready-Data/parted.name.csv");

partData <- mutate(partData, Name = partName[ID,2] )%>%
            filter(n>0) %>%
            arrange(desc(r))


prezPD <- partData[,c("Name","n","A","r")]
colnames(prezPD) <- c("Name","Number of Students","Total Amount Invested","Increase in Poverty Allevation (ROI)")
write.csv(prezPD,"Final-Data/Top-20-Schools.csv")


fullData <- read.csv("Maximized-Data/full.csv");
colnames(fullData) = c("ID", "n", "A", "r")
fullName <- read.csv("Matlab-Ready-Data/full.name.csv");

fullData <- mutate(fullData, Name = fullName[ID,2] )%>%
            filter(n>0) %>%
            arrange(desc(r))


