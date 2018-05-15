# In this script, I attempt to further differentiate projects by text
# Heavily uses code from Dr. Reza Mousavi, a professor at UNCC


# Self Note: Going to switch the topic modeling code using https://www.kaggle.com/rtatman/nlp-in-r-topic-modelling/code as a reference 

library(data.table)
library(dplyr)
library(tidytext)
library(wordcloud)
library(ggplot2)
library(tidyr)



# additional column to investigate: `Project Subject Category Tree`

text_data <- fread('data/Projects.csv') %>%
  select(`Project ID`,`Project Essay`)

# at the moment, we are forced to heavily downsample the data for performance

text_data_sample <- sample_frac(text_data,.10)


text_df <- text_data_sample %>% 
  unnest_tokens(word,`Project Essay`) %>%
  filter(word != 'donotremoveessaydivider') %>%
  anti_join(stop_words)


text_df %>%
  count(word, sort = TRUE) 


text_df %>%
  count(word, sort = TRUE) %>%
  top_n(20,wt = n) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_bar(stat = "identity") +
  xlab(NULL) +
  coord_flip()


# Using the TDIF approach

text_df_2 <- text_df %>%
  count(`Project ID`, word, sort = TRUE) %>% # It will count the number of words per user
  ungroup()

head(text_df_2)


total_words <- text_df_2 %>% 
  group_by(`Project ID`) %>% 
  summarize(total = sum(n))

head(total_words)

essay_words <- left_join(text_df_2, total_words) 

essay_words  <- essay_words  %>%
  bind_tf_idf(word, `Project ID`, n)

head(essay_words,20)

text_df %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))



# Topic modeling

library(RTextTools)
library(tm)
library(wordcloud)
library(topicmodels)
library(slam)

data <- text_data[1:1000,]

clean_words <-removeWords(data$`Project Essay`, c('<!--donotremoveessaydivider-->','donotremoveessaydivider','--donotremoveessaydivider--',
                                                  '<!---->')) 

data$`Project Essay` <- clean_words



(head(data,1))

corpus <- Corpus(VectorSource(data$`Project Essay`), readerControl=list(language="en"))

tweet_dtm <- DocumentTermMatrix(corpus, control = list(stopwords = TRUE, minWordLength = 3, removeNumbers = TRUE, removePunctuation = TRUE))
tweet_dtm


lda <- LDA(tweet_dtm, k = 3, control = list(seed = 1234))
lda

lda_td <- tidy(lda)
lda_td


top_terms <- lda_td %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

beta_spread <- lda_td %>%
  mutate(topic = paste0("topic", topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  mutate(dif_12 = abs(topic1 - topic2)) %>%
  arrange(desc(dif_12))

beta_spread
