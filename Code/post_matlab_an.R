rm(list=ls())
require('dplyr')

setwd("C:/Github/school-invst-str/Code")

partData <- read.csv("Maximized-Data/partitioned.csv");
colnames(partData) = c("ID", "A")
partName <- read.csv("Matlab-Ready-Data/parted.name.csv");

partData <- mutate(partData, Name = partName[ID,2] )

fullData <- read.csv("Maximized-Data/full.csv");
colnames(fullData) = c("ID", "A")
fullName <- read.csv("Matlab-Ready-Data/full.name.csv");

fullData <- mutate(fullData, Name = fullName[ID,2] )
