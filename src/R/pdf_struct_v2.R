library(pdftools)
library(wordcloud)
library(wordcloud2)
library(tm)
library(dplyr)
library(stringr)

rm(list=ls())
setwd("C:/Users/Faiz/Desktop/G4/dat/")

########
doc <- "./pdf_source/IPCC_AR6_WGI_SPM_final.pdf" 
       #(change this here for a new *.pdf)

################################################################
#extract text, and other info
txt <- pdf_text(doc) #content as text in vector of strings, per page
toc <- pdf_toc(doc)  #table of contents
info <- pdf_info(doc) #metadata
#dat <- pdf_data(doc)  # a large list of dataframes per page, 1 line per page? 

######################
#loop to clean, make dataframe, link to IDand export as csv
for ( i in 1:length(txt))
{
  txt[i] <- str_replace_all(txt[i], "[[:punct:]]", "")
  txt[i] <- str_squish(txt[i])
}
df <- as.data.frame(txt)
df <- mutate(df, PG = row_number())
df$ID <- 10    #add column to link to #ID from index
df <- df[, c("ID","PG","txt")]
write.csv(df, "./pdf_structd/doc10.csv", row.names = FALSE)
                       #(change this # here for a new *.csv)
######repeat this loop above for a new pdf

