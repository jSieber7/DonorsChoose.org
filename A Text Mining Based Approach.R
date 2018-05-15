# In this script, I attempt to further differentiate projects by text

library(data.table)
library(dplyr)
library(tidytext)
library(wordcloud)
library(ggplot2)


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
  filter(n > 1000) %>%
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

text_df %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))
