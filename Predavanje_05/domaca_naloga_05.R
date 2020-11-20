setwd("C:/Users/Gregor/Documents/shared_files/workshops/R-za-neprogramerje/Predavanje_05")
df <- read.csv("./data_raw/delci2.csv")
df$Datum <- as.Date(df$Datum, format = "%m/%d/%Y")
head(df)

library(ggplot2)
weekdays(df$Datum)
vikend <- weekdays(df$Datum) == "sobota" | 
  weekdays(df$Datum) == "nedelja"
vikend

df$je_vikend <- vikend
head(df)

ggplot(df, aes(x = Datum, y = PM10)) +
  geom_line() +
  geom_point(aes(colour = je_vikend)) +
  facet_wrap(~ kraj, nrow = 3) +
  labs(colour = "Vikend?") +
  theme(axis.text.x = element_text(angle = 45))