# The Goal of this Project is to see just how 










Donations <- fread('data/Donations.csv')
Donors <- fread('data/Donors.csv')
Projects <- fread('data/Projects.csv')
Resources <- fread('data/Resources.csv')
Schools <- fread('data/Schools.csv')
Teachers <- fread('data/Teachers.csv')




# Investigating Donations

Donations[, `Donation Received Date` := anytime::anydate(`Donation Received Date`)]

Donation_by_day <- Donations[`Donation Received Date` > as.Date('2015-1-20'),.(Total_Donations = sum(`Donation Amount`)), by = `Donation Received Date`]
Donation_by_day[, Year := format(`Donation Received Date`, '%Y')]

ggplot(Donation_by_day, aes(`Donation Received Date`, Total_Donations)) +
  geom_line(size = 1, aes(color = Year)) +
  theme(legend.position="none")


length(unique(Donations$`Project ID`)) / nrow(Donations)
length(unique(Donations$`Donation ID`)) / nrow(Donations)
length(unique(Donations$`Donor ID`)) / nrow(Donations)

ggplot(Donations[`Donation Amount` < 1000], aes(`Donation Amount`)) +
  geom_histogram()

ggplot(Donations[`Donation Amount` < 600], aes(`Donation Amount`)) +
  geom_histogram(binwidth = 25, fill = 'skyblue', color = 'black') +
  scale_x_continuous(breaks = seq(0, 600, by = 25)) +
  labs(title = '(covers over 99% of the data)')

nrow(Donations[`Donation Amount` < 600]) / nrow(Donations)


