#text mining from pdf extraction

# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

#read text file

text <- readLines("./dat/doc1.txt")

# Load the data as a corpus
docs <- Corpus(VectorSource(text))

#inspect(docs)

#clean

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("just", "many", "etc", "smart", "grid", "power", "energy", "system", "systems", "grids", "new", "yes", 
                                    "including")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
#docs <- tm_map(docs, stemDocument)

#inspect(docs)

#term matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 100)
d

#word cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

#barplot
barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word,
        col ="lightblue", main ="Most frequent words (rank 1-20)",
        ylab = "Word frequencies")
barplot(d[21:40,]$freq, las = 2, names.arg = d[21:40,]$word,
        col ="lightblue", main ="Most frequent words (rank 21-40)",
        ylab = "Word frequencies")
barplot(d[41:60,]$freq, las = 2, names.arg = d[41:60,]$word,
        col ="lightblue", main ="Most frequent words (rank 41-60)",
        ylab = "Word frequencies")
barplot(d[61:80,]$freq, las = 2, names.arg = d[61:80,]$word,
        col ="lightblue", main ="Most frequent words (rank 61-80)",
        ylab = "Word frequencies")
barplot(d[81:100,]$freq, las = 2, names.arg = d[81:100,]$word,
        col ="lightblue", main ="Most frequent words (rank 81-100)",
        ylab = "Word frequencies")

findFreqTerms(dtm, lowfreq = 3)

#findAssocs(dtm, terms = "ai", corlimit = 0.1)
