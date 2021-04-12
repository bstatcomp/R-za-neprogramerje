library(ggplot2)

setwd("/home/jana/git/R-za-neprogramerje/Predavanje_05")

ggplot()
df.osebe <- read.table("./data_raw/osebe.csv", header=TRUE, sep=",", 
                       quote= "\"", dec=".")

ggplot(df.osebe, aes(x= Visina, y=Teza, colour = Spol)) + 
  geom_point()

ggplot(df.osebe, aes(x = Spol)) + geom_bar()
ggplot(df.osebe, aes(x = Spol)) + geom_bar(stat="count")

ggplot(df.osebe, aes(x= Ime, y= Starost)) + 
  geom_bar(stat= "identity")

df.klubi.dolga <- read.table("./data_raw/klubi_dolga.csv", 
                             header=TRUE, sep=",", 
                             quote="\"", dec = ".")

ggplot(df.klubi.dolga, aes(x=Sezona, y=Tocke, colour = Klub, group = Klub)) + 
  geom_point() + geom_line()

ggplot(df.klubi.dolga, aes(x=Sezona, y=Tocke, group = Klub)) + 
  geom_line()

#ggsave(kam, kaj)- kako shranimo graf

g1 <-ggplot(df.osebe, aes(x= Visina, y=Teza, colour = Spol)) + 
        geom_point()

plot(g1) # izris g1

ggsave("./plots/graf1.pdf", g1, width = 14, height= 10, dpi = 300)

###############

df.klubi <- read.table("./data_raw/klubi.csv", 
                 header=TRUE, sep=",", 
                 quote="\"", dec = ".")

library(tidyr)
pod <- pivot_longer(df.klubi, cols = 3:7)
colnames(pod) <- c("Klub", "Mesto", "Sezona", "Tocke")

pod2 <- pivot_longer(df.klubi, cols = Sez_2015:Sez_2019 , names_to = "Sezona", 
                    values_to = "Tocke")


ggplot(df.osebe, aes(x= Visina, y=Teza, colour = Spol)) + 
  geom_point() + xlab("višina (v cm)") + ylab("teža (v kg)") + 
  xlim(0, 200) + ylim(0, 100) + ggtitle("Višina in teža udeležencev") +
  theme(plot.title = element_text(hjust = 0.5))
