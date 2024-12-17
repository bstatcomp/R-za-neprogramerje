## t-test
## --------------------------------------------------------------------------------------------------------
# t-test uporabimo za statistièno primerjavo prièakovane širine listov
# dveh vrst perunike.
head(iris)
x_vir <- iris$Sepal.Width[iris$Species == "virginica"]
x_ver <- iris$Sepal.Width[iris$Species == "versicolor"]

t.test(x_vir, x_ver)


## ANOVA
## --------------------------------------------------------------------------------------------------------
# ANOVO uporabimo za statistièno primerjavo dolžine listov treh vrst perunike.
# Primerjamo, ali vrsta perunike vpliva na dolžino listov.
my_anova <- aov(Sepal.Length ~ Species, data = iris)
summary(my_anova)


## ggplot2 -- statistièna znaèilnost.
## --------------------------------------------------------------------------------------------------------
library(ggplot2)
library(ggpubr)
ggplot(iris, aes(x = Species, y = Petal.Width)) +
  geom_boxplot() +
  stat_compare_means(label = "p.signif", method = "t.test",
                     ref.group = "setosa")


## Jitter, dodge, povpreèja.
## --------------------------------------------------------------------------------------------------------
library(tidyr)
iris_longer <- iris[ , c("Sepal.Length", "Sepal.Width", "Species")]
iris_longer <- pivot_longer(iris_longer, Sepal.Length:Sepal.Width)
head(iris_longer)

library(ungeviz)
ggplot(iris_longer, aes(x = Species, y = value, color = name)) +
  geom_point(position = position_jitterdodge()) +
  stat_summary(
    fun = "mean",
    position = position_dodge(width = 0.75),
    geom = "hpline"
  )


## Errorbars
## --------------------------------------------------------------------------------------------------------
data("mtcars")
head(mtcars)

mus <- aggregate(mpg ~ cyl, mtcars, FUN = mean)
sds <- aggregate(mpg ~ cyl, mtcars, FUN = function(x) {sd(x) / sqrt(length(x))})
df  <- cbind(mus, SE = sds$mpg)
df$cyl <- as.character(df$cyl)
head(df)

ggplot(df, aes(x = cyl, y = mpg, colour = cyl)) + 
  geom_point() + 
  geom_errorbar(aes(ymin = mpg - SE, ymax = mpg + SE), width = 0.5) +
  theme(legend.position = "none")


## SPSS
## --------------------------------------------------------------------------------------------------------
library(haven)
podatki <- read_sav("./data_raw/osebe.sav")
podatki

write_sav(iris, "./data_clean/iris.sav")


## Urejanje data.frame.
## --------------------------------------------------------------------------------------------------------
head(mtcars)
cars_increasing <- mtcars[order(mtcars$hp), ]
cars_increasing[1:10, ]

order(c(5, 2, 3, 1))

cars_decreasing <- mtcars[order(mtcars$hp, decreasing = TRUE), ]
cars_decreasing[1:10, ]

cars_subset <- mtcars[mtcars$hp < 100, ]
cars_subset

nrow(mtcars[mtcars$hp < 100, ])


## Manjkajoèe vrednosti.
## --------------------------------------------------------------------------------------------------------
x <- c(4, 6, 1, NA, 5, NA, 6)

anyNA(x)

is.na(x[1])
is.na(x[4])

mean(x)

mean(x, na.rm = TRUE)
mean(x[!is.na(x)])


## Nekonsistentni podatki.
## --------------------------------------------------------------------------------------------------------
podatki <- read.table("./data_raw/nekonsistentni_podatki.csv", dec = ",", sep = ";", 
                      quote = "", header = TRUE)
head(podatki)
str(podatki)

# Menjava podniza.
stavek <- "Ne maram R!"
gsub(pattern = "Ne maram", replacement = "Obozujem", x = stavek)

podatki$vrednost <- gsub(pattern = ",", replacement = ".", x = podatki$vrednost)
podatki$vrednost <- as.numeric(podatki$vrednost)
head(podatki)


## Branje iz Excela iz poljubne vrstice/stolpca.
## --------------------------------------------------------------------------------------------------------
library(openxlsx)
podatki <- read.xlsx("./data_raw/podatki_premaknjeni.xlsx", startRow = 14)
head(podatki)

podatki <- read.xlsx("./data_raw/podatki_premaknjeni2.xlsx", startRow = 14, cols = 9:10)
head(podatki)


## Avtomatsko generiranje poroèil.
## ---- eval = FALSE---------------------------------------------------------------------------------------
## rmarkdown::render("<ime-Rmd-datoteke>",
##                   output_file = "<ime-izhodne-datoteke-s-koncnico>",
##                   output_format = "<format-izhodne-datoteke>")


## Dvojna glava (header).
## ---- eval = TRUE----------------------------------------------------------------------------------------
library(zoo)
head1 <- unlist(read.table("./data_raw/dvojni_header.csv", sep = ";", 
                           quote = "", nrow = 1))
head1

head2 <- unlist(read.table("./data_raw/dvojni_header.csv", sep = ";", 
                           quote = "", nrow = 1, skip = 1))
head2

tmp <- na.locf(unlist(head1), na.rm = FALSE)
tmp

my_header <- paste(head2, tmp, sep = "_")
my_header

podatki <- read.table("./data_raw/dvojni_header.csv", sep = ";", quote = "", skip = 2,
                      header = FALSE)
colnames(podatki) <- my_header
podatki_long      <- pivot_longer(podatki, m_2018:f_2019)
head(podatki_long)

# Urejanje.
podatki_long$spol <- gsub("\\_.*", "", podatki_long$name)
podatki_long$leto <- gsub(".*\\_", "", podatki_long$name)
podatki_long$name <- NULL
head(podatki_long)


## Dva data.frame kot vhodni podatek ggplot.
## --------------------------------------------------------------------------------------------------------
pojav_x  <- seq(0, 10, by = 0.1)
pojav_y  <- sin(pojav_x)
vzorci_x <- c(2, 4, 6, 6.5, 9)
vzorci_y <- c(0.5, -0.5, 0, 1, 0.5)
df1 <- data.frame(x = pojav_x, y = pojav_y)
df2 <- data.frame(x = vzorci_x, y = vzorci_y)

ggplot() +
  geom_line(data = df1, mapping = aes(x = x, y = y)) +
  geom_point(data = df2, mapping = aes(x = x, y = y))


## Frekvenèno vzorèenje.
## --------------------------------------------------------------------------------------------------------
timestamp_A <- read.table(file = './data_raw/A.csv', header = F, nrows = 1)
frequency_A <- read.table(file = './data_raw/A.csv', header = F, nrows = 1, skip = 1)
y_A         <- read.table(file = './data_raw/A.csv', header = F, skip = 2)
step_size_A <- as.numeric(1 / frequency_A)
n_y_A       <- nrow(y_A)
t_A         <- seq(step_size_A, n_y_A * step_size_A, by = step_size_A)
df1         <- data.frame(x = t_A, y = y_A, type = "A")
colnames(df1)   <- c("seconds", "measurement", "type")
df1$measurement <- scale(df1$measurement)
head(df1)

timestamp_B <- read.table(file = './data_raw/B.csv', header = F, nrows = 1)
frequency_B <- read.table(file = './data_raw/B.csv', header = F, nrows = 1, skip = 1)
y_B         <- read.table(file = './data_raw/B.csv', header = F, skip = 2)
step_size_B <- as.numeric(1 / frequency_B)
n_y_B       <- nrow(y_B)
t_B         <- seq(step_size_B, n_y_B * step_size_B, by = step_size_B)
df2         <- data.frame(x = t_B, y = y_B, type = "B")
colnames(df2)   <- c("seconds", "measurement", "type")
df2$measurement <- scale(df2$measurement)
head(df2)

df <- rbind(df1, df2)
ggplot(df, aes(x = seconds, y = measurement, color = type)) + geom_line()


## dplyr -- paket za manipulacijo podatkov.
## --------------------------------------------------------------------------------------------------------
library(dplyr)

# filter
head(filter(mtcars, hp > 90)) # dplyr
head(mtcars[mtcars$hp > 90, ]) # base R

# select
head(select(mtcars, mpg, cyl, hp)) # dplyr
head(mtcars[ , c("mpg", "cyl", "hp")]) # base R

# mutate
head(mutate(mtcars, nov_stolpec = mpg + cyl * hp)) # dplyr
tmp <- mtcars # base R -- 3 vrstice
tmp$nov_stolpec <- tmp$mpg + tmp$cyl * tmp$hp
head(tmp)

# summarize 
summarize(group_by(mtcars, cyl), mean_hp = mean(hp)) # dplyr
aggregate(mtcars$hp, by = list(mtcars$cyl), FUN = mean) # base R


## Dve osi na ggplot.
## ----fig.width = 3, fig.height = 3-----------------------------------------------------------------------
x  <- c("0-18", "19-30", "30-50", "50+")
y1 <- c(1, 1.2, 2, 4)
y2 <- c(32, 10, 15, 10)
df <- data.frame(x = x, y1 = y1, y2 = y2)

ggplot(df) +
  geom_line(aes(x = x, y = y1, group = 1)) +
  geom_bar(aes(x = x, y = y2 / 8 / 6), stat = "identity") +
  scale_y_continuous(
    name = "Vrednost",
    sec.axis = sec_axis(trans=~. * 8 * 6, name="Stevilo v skupini")
  )


## Pokritost genoma.
## --------------------------------------------------------------------------------------------------------
# Najprej generiramo sintetiène podatke, ki ilustrirajo pokritost genoma.
x  <- seq(0, 7000, by = 1000)
y1 <- c(1000, 2000, 1000, 1000, 500, 1500, 2500, 2200)
y2 <- c(1000, 1800, 1200, 1200, 700, 1000, 1500, 1700)
df <- data.frame(x = x, y1 = y1, y2 = y2)
df_longer <- pivot_longer(df, y1:y2)
head(df_longer)

g1 <- ggplot(df_longer, aes(x = x, y = value)) + 
  geom_area(fill = "lightblue") + 
  facet_grid(name ~ .)

# Generiramo sintetiène podatke, ki ilustrirajo anotacijo genoma.
tmp2 <- data.frame(x = c("annot_1", "annot_2"), y_start = c(6000, 5000), 
                   y_end = c(7000, 6100))
tmp2

g2 <- ggplot(tmp2, aes(x = x)) + 
  geom_errorbar(aes(ymin = y_start, ymax = y_end)) +
  geom_text(aes(label = x, y = y_start), hjust = 1.5) +
  coord_flip() +
  scale_y_continuous(position = "right", limits = c(0, 7000)) 

# Združimo grafa.
egg::ggarrange(g2, g1, ncol = 1, heights = c(1, 2))


## Pripenjanje data.frame z razliènimi stolpci.
## --------------------------------------------------------------------------------------------------------
height1 <- c(171, 185, 165)
weight1 <- c(70, 78, 64)
name1   <- c("Alen", "Bojan", "Cvetka")
height2 <- c(190, 152)
name2   <- c("Dejan", "Eva")
df1     <- data.frame(height = height1, weight = weight1, name = name1)
df2     <- data.frame(name = name2, height = height2)
df      <- bind_rows(df1, df2)
df


## Browser.
## ---- eval = FALSE---------------------------------------------------------------------------------------
for (i in 1:10) {
  x <- 2 * i
  y <- x + 5
  if (y > 10) {
    browser()
  }
}

