library(rtweet)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
library(dendroTools) # fOR round_df
library(TSstudio) #tsplot
library(ggplot2)  #pLOT
library(tidytext)
library(wordcloud)
library(tm)
library(DT)

options(warn = -1)

# Twitter Cred

twitter_token <- create_token(
  app = "Personal Insight",
  consumer_key = "SFzUTzvltwVwhLOPcoFXNcLil" ,
  consumer_secret = "ae0hnfBm8jys8XABA7vLbGSeLwyQie09xCYHie0DZj1KoygiyG",
  access_token = "881373068807065600-th9Am7WPvBXBxhfXi6SesBqK8vVoiDA",
  access_secret= "BFTIACOtNjdMU7tNwGqbWi3TBEh6KtgBDJgNKsPE3yLXq",
  set_renv = TRUE)

climate <- search_tweets("climate",n=1000, include_rts=FALSE,lang="en")

# user_id <- readline(prompt = "Enter Twitter Handle:")
user_id <- 'ArvindKejriwal' 
User_tweets <- get_timeline(user_id,n= 3200)

# User


####
timeline <- ts_plot(climate)
timeline

# ts_plot(climate,"1 month")+
#     ggplot

#Remove re tweets

User_tweets_organic <- User_tweets[User_tweets$is_retweet==FALSE,]


#Remove Replies

User_tweets_organic <- subset(User_tweets_organic,is.na(User_tweets_organic$reply_to_status_id))

User_tweets_organic <- User_tweets_organic %>% arrange(-favorite_count)
User_tweets_organic[1,5]
User_tweets_organic <- User_tweets_organic %>% arrange(-retweet_count)
User_tweets_organic[1,5]

# Keeping only the retweets
User_retweets <- User_tweets[User_tweets$is_retweet==TRUE,]
# Keeping only the replies
User_replies <- subset(User_tweets, !is.na(User_tweets$reply_to_status_id))

# Creating a data frame
data <- data.frame(
  category=c("Organic", "Retweets", "Replies"),
  count=c(2856, 192, 120)
)

# Adding columns 
data$fraction = data$count / sum(data$count)
data$percentage = data$count / sum(data$count) * 100
data$ymax = cumsum(data$fraction)
data$ymin = c(0, head(data$ymax, n=-1))

# Rounding the data to two decimal points
data <- round_df(data, 2)

# Specify what the legend should say
Type_of_Tweet <- paste(data$category, data$percentage, "%")
compose_tw <- ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Type_of_Tweet)) +
  geom_rect() +
  coord_polar(theta="y") + 
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "right")
compose_tw
# Save plot compose_tw
ggsave(filename = "compose_tw.png", path = "result/",width = NA, height = NA, device = 'png', dpi=700 , )


colnames(User_tweets)[colnames(User_tweets)=="screen_name"] <- "Twitter_Account"



User_app <- User_tweets %>% 
  select(source) %>% 
  group_by(source) %>%
  summarize(count=n())
User_app <- subset(User_app, count > 11)


data <- data.frame(
  category=User_app$source,
  count=User_app$count
)
data$fraction = data$count / sum(data$count)
data$percentage = data$count / sum(data$count) * 100
data$ymax = cumsum(data$fraction)
data$ymin = c(0, head(data$ymax, n=-1))
data <- round_df(data, 2)
Source <- paste(data$category, data$percentage, "%")
compose_dev <- ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Source)) +
  geom_rect() +
  coord_polar(theta="y") + # Try to remove that to understand how the chart is built initially
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "right")
compose_dev
# Save Plot compose_dev
ggsave(filename = "compose_dev.png", path = "result/",width = NA, height = NA, device = 'png', dpi=700 , )

User_tweets_organic$text <-  gsub("https\\S*", "", User_tweets_organic$text)
User_tweets_organic$text <-  gsub("@\\S*", "", User_tweets_organic$text) 
User_tweets_organic$text  <-  gsub("amp", "", User_tweets_organic$text) 
User_tweets_organic$text  <-  gsub("[\r\n]", "", User_tweets_organic$text)
User_tweets_organic$text  <-  gsub("[[:punct:]]", "", User_tweets_organic$text)
tweets <- User_tweets_organic %>%
  select(text) %>%
  unnest_tokens(word, text)
tweets <- tweets %>%
  anti_join(stop_words)
tweets %>% # gives you a bar chart of the most frequent words found in the tweets
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Most frequent words found in the tweets of User",
       subtitle = "Stop words removed from the list")
## Save frequency Chart
ggsave(filename = "freq.png", path = "result/",width = NA, height = NA, device = 'png', dpi=700 , )



# Word Cloud


User_tweets_organic$hashtags <- as.character(User_tweets_organic$hashtags)
User_tweets_organic$hashtags <- gsub("c\\(", "", User_tweets_organic$hashtags)

set.seed(1234)
wordcloud(User_tweets_organic$hashtags, min.freq=10, scale=c(3.5, .5), random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

# # save it in html
# library("htmlwidgets")
# saveWidget(wc1,"tmp.html",selfcontained = F)
# # and in png
# webshot("tmp.html","wc1.png", delay =5, vwidth = 480, vheight=480) # changed to png. 


set.seed(1234)
wordcloud(User_retweets$retweet_screen_name, min.freq=7, scale=c(2, .5), random.order=FALSE, rot.per=0.25, 
          colors=brewer.pal(8, "Dark2"))


library(syuzhet)


# Converting tweets to ASCII to trackle strange characters
tweets <- iconv(tweets, from="UTF-8", to="ASCII", sub="")
# removing retweets, in case needed 
tweets <-gsub("(RT|via)((?:\\b\\w*@\\w+)+)","",tweets)
# removing mentions, in case needed
tweets <-gsub("@\\w+","",tweets)
ew_sentiment<-get_nrc_sentiment((tweets))
sentimentscores<-data.frame(colSums(ew_sentiment[,]))
names(sentimentscores) <- "Score"
sentimentscores <- cbind("sentiment"=rownames(sentimentscores),sentimentscores)
rownames(sentimentscores) <- NULL
ggplot(data=sentimentscores,aes(x=sentiment,y=Score))+
  geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Personal Insight")+ylab("Scores")+
  ggtitle("Total sentiment based on scores")+
  theme_minimal()
## SAve plot Personality
ggsave(filename = "Personality.png", path = "result/",width = NA, height = NA, device = 'png', dpi=700 , )
options(warn = -1)




