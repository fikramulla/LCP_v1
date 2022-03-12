library(pdftools)
library(wordcloud)
library(wordcloud2)
library(tm)
library(dplyr)

rm(list=ls())

########
setwd("C:/Users/Faiz/Desktop/G4/")
doc2 <- "./dat/pdf_source/IPCC_AR6_WGI_SPM_final.pdf"

################################################################
#extract text, and other info
txt <- pdf_text(doc2)
cat(txt[[1]])  #cat of 1st page

#export as png
bitmap <- pdf_render_page(doc2, page = 1)
png::writePNG(bitmap, "./img/doc2_page1.png")
bitmap2 <- pdf_render_page(doc2, page = 2)
png::writePNG(bitmap, "./img/doc2_page2.png")

toc <- pdf_toc(doc2)
cat(toc)  #blank on this one

info <- pdf_info(doc2)
cat(info[["created"]])  #as list (date yes), but in double format 

#EDA
class(txt)  #character vector type
#?how to change to data frame or break up by headings?
df <- as.data.frame(txt)
df[2,1]  #one row per page of pdf

indf <- as.data.frame(info)  #grab descriptors
indf <- t(indf)   #transpose

#export as csv and/or txt
write.csv(df, "./dat/doc2.csv", row.names = FALSE)
write.csv(df, "./dat/doc2.txt", row.names = FALSE)

write.csv(indf, "./dat/inf_doc2.csv", row.names = FALSE)
write.csv(indf, "./dat/inf_doc2.txt", row.names = FALSE)  #displays as table in R but extracts as xml i think!
#really just need to grab date created and modified and author and sourece info, try again later

#Analytics/Visualizaitons - see pdf_WordCount_cloud_exp1

#1.  Word Frequency


#2.  Word Proximity


#3.  Keywords


#4.  Entities


#5.  Time Reference






