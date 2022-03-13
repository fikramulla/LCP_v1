library(pdftools)
library(wordcloud)
library(wordcloud2)
library(tm)
library(dplyr)

rm(list=ls())

########
setwd("C:/Users/Faiz/Desktop/G4/")
doc3 <- "./dat/pdf_source/The-Sustainable-Development-Goals-Report-2021_English.pdf"

################################################################
#extract text, and other info
txt <- pdf_text(doc3)
cat(txt[[10]])  #cat of 1st page

#try pdf_data
df <- pdf_data(doc3)
#hmmm... what is this? ("a list of 68 elements)









#export as png (deleted, trying to work with data frame)
#bitmap <- pdf_render_page(doc3, page = 1)
#png::writePNG(bitmap, "./img/doc2_page1.png")
#bitmap2 <- pdf_render_page(doc3, page = 2)
#png::writePNG(bitmap, "./img/doc2_page2.png")


##### revisit this ########
toc <- pdf_toc(doc3)
cat(toc)  #blank on this one

info <- pdf_info(doc3)
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






