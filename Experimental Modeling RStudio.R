library(caret)
library(keras)
library(data.table)
library(ggplot2)
library(scales)
library(dplyr)
library(tidyr)


# Modeling Donors

# First Step? Link all donations up

Donations <- fread('data/Donations.csv')
Donors <- fread('data/Donors.csv')
Projects <- fread('data/Projects.csv')
Resources <- fread('data/Resources.csv')
Schools <- fread('data/Schools.csv')
Teachers <- fread('data/Teachers.csv')


# https://stackoverflow.com/questions/9845929/removing-a-list-of-columns-from-a-data-frame-using-subset?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
`%ni%` <- Negate(`%in%`)


Repeated_Donors <- Donations[,.(`Times Donated`=.N, `Total of All Donations by Donor` = sum(`Donation Amount`)),by=`Donor ID`]


Donations_Linked <- merge(Donations,Projects) %>%
  merge(Donors, by = 'Donor ID') %>%
  merge(Repeated_Donors, by = 'Donor ID') %>%
  merge(Teachers, by = 'Teacher ID') %>%
  merge(Schools, by = 'School ID')
  
Unwanted_Columns <- c("School ID","Teacher ID","Donor ID","Project ID", 'Donation ID',
                      'Donation Received Date','Project Title','Project Essay',
                      'Project Subject Category Tree', 'Project Subject Subcategory Tree',
                      'Project Grade Level Category','Project Resource Category',
                      'Project Posted Date','Project Fully Funded Date','Donor City',
                      'Donor State','Donor Zip','Teacher First Project Posted Date',
                      'School Name','School Zip','School City','School County',
                      'School District','School State')





Donations_Linked = subset(Donations_Linked,select = names(Donations_Linked) %ni% Unwanted_Columns)




library(recommenderlab)	 	 
# Loading to pre-computed affinity data	 
affinity.data<-Donations_Linked







affinity.matrix<- as(affinity.data,"realRatingMatrix")


Rec.model<-Recommender(affinity.matrix[1:5000], method = "UBCF")


Rec.model=Recommender(affinity.data[1:400],method="UBCF", 
                      param=list(normalize = "Z-score",method="Cosine",nn=5, minRating=1))










categories <- Projects %>%
  select(`Project Subject Category Tree`) %>%
  mutate(`Project Subject Category Tree`=strsplit(as.character(`Project Subject Category Tree`), ",")) %>% 
  unnest(`Project Subject Category Tree`)

as.data.frame(table(categories))


# indicates a refactoring could be useful
table(Projects$`Project Resource Category`)


Repeated_Donors <- Donations[,.(`Times Donated`=.N, `Total of All Donations by Donor` = sum(`Donation Amount`)),by=`Donor ID`]

View(head(test,200))

table(cat)

cat[,.N,by =`Project Subject Category Tree`]

cat %>%
  group_by(`Project Subject Category Tree`) %>%
  summarise(countf = .N)

head(Projects)

write.csv(head(test,50),'test.csv')
