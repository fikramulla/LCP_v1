#continued from nlp_edge_docx.R - where only one page, and manual images
#this attempts to get all the info from all pages of 1 doc, auto-capture
#all plots, and get it ready to run through my python creat_edge_list
#03/22/2022

rm(list=ls())
setwd("C:/Users/fikramulla/Desktop/_tiger")

library(dplyr)
library(stringr)
library(ggplot2)
library(tm)
library(wordcloud2) 
library(syuzhet)
library(stringi)
library(sqldf)

#*************
#LOAD, READ, PROCESS, EXTRACT
#*************
#read structured csv of doc x (one row per page - doc_1 has 52 rows, doc_8 has 3949 rows aka pages)
text <- read.csv("./dat/doc6.csv")
txt <- data.frame(matrix(ncol = 1, nrow = 0))  #initialize
colnames(txt) <- c('text')

#special for docx
txt <- text[,3]
docs <- Corpus(VectorSource(txt))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("just", "many", "etc", "figure", "table", "chapter", "change", "no", "yes", 
                                    "including", "total", "also", "iucn")) 

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)


# for(i in 1:nrow(text)) {
#   txt[i,] <- text[i,3]  #select text column of docx.csv (3rd column), per page
#   docs <- Corpus(VectorSource(txt))  #this does all pages at once
#   docs <- tm_map(docs, content_transformer(tolower))
#   docs <- tm_map(docs, removeNumbers)
#   docs <- tm_map(docs, removeWords, stopwords("english"))
#   docs <- tm_map(docs, removeWords, c("just", "many", "etc", "figure", "table", "chapter", "change", "no", "yes", 
#                                       "including", "total", "also")) 
#   docs <- tm_map(docs, removePunctuation)
#   docs <- tm_map(docs, stripWhitespace)
#   dtm <- TermDocumentMatrix(docs)
#   m <- as.matrix(dtm)
#   v <- sort(rowSums(m),decreasing=TRUE)
#   d <- data.frame(word = names(v),freq=v)
# }

#word count
d1 <- d[1:20,]

#sentiments per page (d3) and summed across whole document (d4)
#d2 <- as.character(txt)
d3 <-get_nrc_sentiment(txt)
d4 <- as.data.frame(colSums(d3))
#td<-data.frame(t(d3))
d4 <- cbind(rownames(d4), d4)
colnames(d4) <- c("sentiment","count")
rownames(d4) <- NULL


#*************
#search/count of sdgs
#*************
dim(d)[1]  #unique words in d

sdg <- read.csv("./dat/lcps_single.csv")
sdg['weight'] <- 0

i = grep("poverty", d$word) ; sdg[1,3] <- d[i[1],]$freq
i = grep("hunger", d$word) ; sdg[2,3] <- d[i[1],]$freq
i = grep("health", d$word) ; sdg[3,3] <- d[i[1],]$freq
i = grep("education", d$word) ; sdg[4,3] <- d[i[1],]$freq
i = grep("gender", d$word) ; sdg[5,3] <- d[i[1],]$freq
i = grep("clean", d$word) ; sdg[6,3] <- d[i[1],]$freq
i = grep("energy", d$word) ; sdg[7,3] <- d[i[1],]$freq
i = grep("work", d$word) ; sdg[8,3] <- d[i[1],]$freq
i = grep("industry", d$word) ; sdg[9,3] <- d[i[1],]$freq
i = grep("inequalities", d$word) ; sdg[10,3] <- d[i[1],]$freq
i = grep("cities", d$word) ; sdg[11,3] <- d[i[1],]$freq
i = grep("consumption", d$word) ; sdg[12,3] <- d[i[1],]$freq
i = grep("climate", d$word) ; sdg[13,3] <- d[i[1],]$freq
i = grep("water", d$word) ; sdg[14,3] <- d[i[1],]$freq
i = grep("land", d$word) ; sdg[15,3] <- d[i[1],]$freq
i = grep("peace", d$word) ; sdg[16,3] <- d[i[1],]$freq

#********
#OUTPUTS & VISUALIZATIONS
#********
#word counts
png("./img_out/counts_doc6.png")
barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word,
        col ="lightblue", main ="Most frequent words (rank 1-20)",
        ylab = "Word frequencies")
dev.off()

#lollipops of top 20 word counts
png("./img_out/lolli_doc6.png", width = 1080, height = 480)
ggplot(d1, aes(x=word, y=freq)) +
  geom_segment( aes(x=word, xend=word, y=0, yend=freq)) +
  geom_point( size=5, color="red", fill=alpha("orange", 0.3), alpha=0.7, shape=21, stroke=2) 
dev.off()

#sentiment
td1<-d4[1:8,]
png("./img_out/sentim_doc6.png")
ggplot(data=td1, aes(x=sentiment, y=count, fill=sentiment)) +
  geom_bar(stat="identity")
dev.off()
td2<-d4[9:10,]
png("./img_out/posneg_doc6.png")
ggplot(data=td2, aes(x=sentiment, y=count, fill=sentiment)) +
  geom_bar(stat="identity")
dev.off()

#sdg's
#barplot of sdgs
png("./img_out/sdglist_doc6.png", width = 1080, height = 480)
ggplot(data=sdg, aes(x=SDG, y=weight, fill=SDG)) +
  geom_bar(stat="identity")
dev.off()
#lollipops of sdgs in this page
png("./img_out/lollisdglist_doc6.png", width = 1080, height = 480)
ggplot(sdg, aes(x=SDG, y=weight)) +
  geom_segment( aes(x=SDG, xend=SDG, y=0, yend=weight)) +
  geom_point( size=5, color="darkgreen", fill=alpha("green", 0.3), alpha=0.7, shape=21, stroke=2) 
dev.off()

#********
#CSV OUTPUTS
#********
write.csv(d, "./csv_out/total_doc6.csv", row.names = FALSE)
write.csv(d1, "./csv_out/counts_doc6.csv", row.names = FALSE)
write.csv(td1, "./csv_out/sentim_doc6.csv", row.names = FALSE)
write.csv(td2, "./csv_out/posneg_doc6.csv", row.names = FALSE)
write.csv(sdg, "./csv_out/sdglist_doc6.csv", row.names = FALSE)

#now go to python to create edgelist...

