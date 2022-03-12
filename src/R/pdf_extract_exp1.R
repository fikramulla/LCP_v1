library(pdftools)
library(wordcloud)
library(wordcloud2)
library(tm)
library(dplyr)

rm(list=ls())

########
setwd("C:/Users/Faiz/Desktop/G4/")
doc1 <- "./dat/pdf_source/IPCC_AR6_WGI_Headline_Statements.pdf"

################################################################
#extract text, and other info
txt <- pdf_text(doc1)
cat(txt[[1]])  #cat of 1st page

#export as png
bitmap <- pdf_render_page(doc1, page = 1)
png::writePNG(bitmap, "./img/doc1_page1.png")
bitmap2 <- pdf_render_page(doc1, page = 2)
png::writePNG(bitmap, "./img/doc1_page2.png")

toc <- pdf_toc(doc1)
cat(toc)  #blank on this one

info <- pdf_info(doc1)
cat(info[["created"]])  #as list (date yes), but in double format 

#EDA
class(txt)  #character vector type
#?how to change to data frame or break up by headings?
df <- as.data.frame(txt)
df[2,1]

#export as csv and/or txt
write.csv(df, "./dat/doc1.csv", row.names = FALSE)
write.csv(df, "./dat/doc1.txt", row.names = FALSE)

#Analytics/Visualizaitons - see pdf_WordCount_cloud_exp1

#1.  Word Frequency


#2.  Word Proximity


#3.  Keywords


#4.  Entities


#5.  Time Reference






