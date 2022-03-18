setwd('/home/jana/git/R-za-neprogramerje/Predavanje_05/')
 
library(ggplot2)

ggplot()

df.osebe <- read.table("./data_raw/osebe.csv", 
                       header = TRUE,
                       sep = ',',
                       quote = "\"",
                       dec = ".")

print(df.osebe)

g2 <- ggplot(df.osebe, aes(x = Visina, y = Teza, colour = Spol)) + 
  geom_point()

ggplot(df.osebe, aes(x= Spol)) + geom_bar(stat = "count")

ggplot(df.osebe, aes(x = Ime, y = Starost)) + geom_bar(stat = "identity")

df.klubi_dolga <- read.table("./data_raw/klubi_dolga.csv",
                             header = TRUE,
                             sep = ',',
                             quote = "\"",
                             dec = ".")
print(df.klubi_dolga)
ggplot(df.klubi_dolga, aes(x = Sezona, y = Tocke, colour = Klub)) + geom_point()

g <- ggplot(df.klubi_dolga, aes(x = Sezona, y = Tocke, colour = Klub, group = Klub)) + 
  geom_point() + geom_line()

a <- 2
print(a)
plot(g)
ggsave("./figure/graf.jpg", width = 4, height =  3, dpi = 300) 

df.klubi <- read.table("./data_raw/klubi.csv",
                             header = TRUE,
                             sep = ',',
                             quote = "\"",
                             dec = ".")
print(df.klubi)
library(tidyr)
pivot_longer(df.klubi, cols = 3:7, names_to = "Sezona", values_to = "Tocke")

pivot_longer(df.klubi, cols = 3:ncol(df.klubi), names_to = "Sezona", values_to = "Tocke")
df.klubi_dolga2 <- pivot_longer(df.klubi, cols = Sez_2015:Sez_2019, names_to = "Sezona", values_to = "Tocke")

ggplot(df.osebe, aes(x = Visina, y = Teza, color = Spol)) + geom_point() +
  ylab("teza (v kg)") + xlab("visina (v cm)") +
  xlim(0, 200) + ylim(0, 100) + 
  ggtitle("Visine in teze udelezencev") 



