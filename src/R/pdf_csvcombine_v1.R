library(dplyr)                                                 
library(plyr)                                                   
library(readr)

rm(list=ls())
setwd("C:/Users/Faiz/Desktop/G4/dat/")

#load all csvs from folder, rbind all
csv_all <- list.files(path = "./pdf_structd",     # Identify all csv files in folder
                       pattern = "*.csv", full.names = TRUE) %>% 
  lapply(read_csv) %>%                                            # Store all files in list
  bind_rows                                                       # Combine data sets into one data set 
#save as 'docall(10).csv'
write.csv(csv_all, "./csv_out/docall10.csv", row.names = FALSE)

#can revisit and only include english
