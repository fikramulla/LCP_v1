#continued from pdf_struct_v2, and wordcloud_V2

rm(list=ls())
setwd("C:/Users/Faiz/Desktop/G4/dat/")

library(dplyr)
library(stringr)
library(ggplot2)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(wordcloud2) 
library(syuzhet)
library(stringi)

#--------------------------------------------------------------------------#
#i was thinking of each doc as a node, now i am thinking each SDG should be a node
#i am thinking i want to think of:
#-each report as an "epidosde"
#-each page as a "scene"
#-each sdg (first column) as a "character"
#count sdgs per page, then determine when 
#from:one , to:another are in the same scene/page - that is my edge list
#ex.
#poverty,hunger,#of times on same page
#...
#--------------------------------------------------------------------------#

#read structured csv of doc 1 (one row per page - doc1 has 52 rows)
text <- read.csv("./pdf_structd/doc1.csv")
#merge into one row, select columns 1 and 3
txt <- filter(text,row_number() == 10)  #pick page 10
txt <- select(txt,3)  #select text column  

#get word vector
# Load the data as a corpus
docs <- Corpus(VectorSource(txt))
#cover lower case, remove numbers, etc. etc.
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("just", "many", "etc", "figure", "table", "chapter", "change", "no", "yes", 
                                    "including", "total")) 
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)

#term matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

#counts
#barplot
d1 <- d[1:20,]
barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word,
        col ="lightblue", main ="Most frequent words (rank 1-20)",
        ylab = "Word frequencies")

#lollipops of top 20
ggplot(d1, aes(x=word, y=freq)) +
  geom_segment( aes(x=word, xend=word, y=0, yend=freq)) +
  geom_point( size=5, color="red", fill=alpha("orange", 0.3), alpha=0.7, shape=21, stroke=2) 

#sentiment
d2 <- as.character(txt)
d3 <-get_nrc_sentiment(d2)
td<-data.frame(t(d3))
td <- cbind(rownames(td), td)
colnames(td) <- c("sentiment","count")
rownames(td) <- NULL
td<-td[1:8,]
ggplot(data=td, aes(x=sentiment, y=count, fill=sentiment)) +
  geom_bar(stat="identity")

write.csv(td, "./csv_setup/sent_doc1_pg10.csv", row.names = FALSE)

#*************
#search/count of sdgs
#*************
#using term matrix d (or txt or d2) and make sdg_single dataframe
str_length(txt)  #this is total characters (i want words)
str_count(txt, "\\w+")  #regex for words, this is correct
dim(d)[1]  #unique words in d

sdg <- read.csv("./csv_setup/sdgs_single")
sdg['weight'] <- 0

i = grep("poverty", d$word) ; sdg[1,3] <- d[i,]$freq
i = grep("hunger", d$word) ; sdg[2,3] <- d[i,]$freq
i = grep("health", d$word) ; sdg[3,3] <- d[i,]$freq
i = grep("education", d$word) ; sdg[4,3] <- d[i,]$freq
i = grep("gender", d$word) ; sdg[5,3] <- d[i,]$freq
i = grep("clean", d$word) ; sdg[6,3] <- d[i,]$freq
i = grep("energy", d$word) ; sdg[7,3] <- d[i,]$freq
i = grep("work", d$word) ; sdg[8,3] <- d[i,]$freq
i = grep("industry", d$word) ; sdg[9,3] <- d[i,]$freq
i = grep("inequalities", d$word) ; sdg[10,3] <- d[i,]$freq
i = grep("cities", d$word) ; sdg[11,3] <- d[i,]$freq
i = grep("comsumption", d$word) ; sdg[12,3] <- d[i,]$freq
i = grep("climate", d$word) ; sdg[13,3] <- d[i,]$freq
i = grep("water", d$word) ; sdg[14,3] <- d[i,]$freq
i = grep("land", d$word) ; sdg[15,3] <- d[i,]$freq
i = grep("peace", d$word) ; sdg[16,3] <- d[i,]$freq

#write.csv(sdg, "./csv_setup/sdglist_doc1_pg10.csv", row.names = FALSE)

#barplot, lollipops of sdgs in this page
ggplot(data=sdg, aes(x=SDG, y=weight, fill=SDG)) +
  geom_bar(stat="identity")
ggplot(sdg, aes(x=SDG, y=weight)) +
  geom_segment( aes(x=SDG, xend=SDG, y=0, yend=weight)) +
  geom_point( size=5, color="darkgreen", fill=alpha("green", 0.3), alpha=0.7, shape=21, stroke=2) 

#********
#from:sdg1  and to:sdg2 edgelist creation !!! lets try it!!!
edge <- read.csv("./csv_setup/edge_v1.csv")

#now need to loop thorugh my new sdg dataframe for each in my edge
#determine if A and B are > 0
#sum A weight + B weight in sdg dataframe = (A,B)(inertia)
#check next A and B combination
#moved to python to creat edge list here... 


