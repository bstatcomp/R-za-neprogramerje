library(openxlsx)
library(ggplot2)

setwd("/home/jana/git/R-za-neprogramerje/Predavanje_00/")

dat <- openxlsx::read.xlsx("./data_raw/odsotnosti_R.xlsx", sheet = 1)
rsn <- openxlsx::read.xlsx("./data_raw/odsotnosti_R.xlsx", sheet = 2)
# Podatki so dostopni na https://archive.ics.uci.edu/ml/datasets/Absenteeism+at+work.
df <- data.frame(rsn,
                 Stevilo = tapply(dat$Razlog, dat$Razlog, length),
                 Vsota
                 = tapply(dat$Ure, dat$Razlog, sum))
df$Opis <- factor(df$Opis, levels = df$Opis[order(df$Stevilo)])
ggplot(df, aes(x = Opis, y = Stevilo)) + geom_bar(stat = "identity") +
  coord_flip()

df$Opis <- factor(df$Opis, levels = df$Opis[order(df$Vsota)])
ggplot(df, aes(x = Opis, y = Vsota)) + geom_bar(stat = "identity") +
  coord_flip()