#continued from nlp4edge_doc1_v1.R (and create_edgelist_vx in colab)

rm(list=ls())
setwd("C:/Users/Faiz/Desktop/G4/dat/")

library(dplyr)
library(ggplot2)
library(stringr)
library(stringi)
library(tidytext)
library(iterators)
library(itertools)
library(sqldf)

list <- read.csv ("./csv_setup/sdglist_doc1_pg10.csv")
blank <- read.csv("./csv_setup/edge_v1.csv")

#tokenize my list of keyworkds (sdgs)
list$token <- row.names(list)
list <- select(list, -ID, - SDG)
list<-list[, c("token","weight")]
