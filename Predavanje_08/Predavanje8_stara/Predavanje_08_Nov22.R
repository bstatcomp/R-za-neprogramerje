setwd("C:/delavnice/R-za-neprogramerje/Predavanje_08")  

# Statistični testi

## t-test
## --------------------------------------------------------------------------------------------------------
# t-test uporabimo za statistično primerjavo pričakovane širine listov
# dveh vrst perunike.
head(iris)
x_vir <- iris$Sepal.Width[iris$Species == "virginica"]
x_ver <- iris$Sepal.Width[iris$Species == "versicolor"]

t.test(x_vir, x_ver)

## ANOVA
## --------------------------------------------------------------------------------------------------------
# ANOVO uporabimo za statistično primerjavo dolžine listov treh vrst perunike.
# Primerjamo, ali vrsta perunike vpliva na dolžino listov.
my_anova <- aov(Sepal.Length ~ Species, data = iris)
summary(my_anova)


## ggplot2 -- statistična značilnost.
## --------------------------------------------------------------------------------------------------------
library(ggplot2)
library(ggpubr)
ggplot(iris, aes(x = Species, y = Petal.Width)) +
  geom_boxplot() +
  stat_compare_means(label = "p.signif", method = "t.test",
                     ref.group = "setosa")


## Jitter, dodge, povprečja.
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


# Risanje stolpičnih diagramov

library(openxlsx)
anketa_raw <- read.xlsx("./data_raw/vpr_predavanje_8.xlsx")
head(anketa_raw)

#  * < 0: **Neodgovorjeno**
#  * 1: **Da**
#  * 2: **Delno**
#  * 3: **Ne**
#  * 4: **Zame ne velja**

anketa <- anketa_raw
anketa[anketa < 0] <- NA
anketa[anketa == 1] <- "Da"
anketa[anketa == 2] <- "Delno"
anketa[anketa == 3] <- "Ne"
anketa[anketa == 4] <- "Zame ne velja"
head(anketa)

anketa[] <- lapply(anketa, factor, levels = c("Da", "Delno",
                                              "Ne", "Zame ne velja"))
head(anketa)

an2 <- anketa_raw
an2[] <- lapply(anketa_raw, factor, levels = c(1,2,3,4), 
                labels = c("Da", "Delno", "Ne", "Zame ne velja"))
head(an2)

library(tidyr)
anketa_long <- pivot_longer(anketa, 1:ncol(anketa),
                            names_to = "Vprasanje",
                            values_to = "Odgovor")
anketa_long

table(anketa_long)

head(data.frame(table(anketa_long)))

anketa_counts <- pivot_wider(data.frame(table(anketa_long, useNA = "no")), 
                             names_from = "Odgovor", values_from = "Freq")
anketa_counts

anketa_fin <- pivot_longer(anketa_counts, 2:5, names_to = "Odgovor", values_to = "Stevilo")
anketa_fin

library(ggplot2)
ggplot(anketa_fin, aes(x = Vprasanje, y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw()

#dodamo številke
ggplot(anketa_fin, aes(x = Vprasanje, y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4)

#odstranimo 0
anketa_fin <- anketa_fin[anketa_fin$Stevilo != 0,]
ggplot(anketa_fin, aes(x = Vprasanje, y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4)

vrstni_red <- anketa_counts[order(anketa_counts$Da),]$Vprasanje
vrstni_red

#pravilni vrstni red
vrstni_red <- anketa_counts[order(anketa_counts$Da,
                                  anketa_counts$Delno,
                                  anketa_counts$Ne,
                                  anketa_counts$`Zame ne velja`),]$Vprasanje
vrstni_red

#dodamo stolpec
anketa_fin$ord <- 0
for(i in 1:length(vrstni_red)){
  #izberemo vse vrstice, ki pripadajo i-temu vprašanju
  sel <- anketa_fin$Vprasanje == vrstni_red[i]
  #dodamo pravilni indeks v ord
  anketa_fin[sel, "ord"] <- length(vrstni_red) - i
}
anketa_fin

#vrstni red stolpcev
ggplot(anketa_fin,
       aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4)

anketa_fin$Odgovor <- factor(anketa_fin$Odgovor, levels = c("Zame ne velja", "Ne",
                                                            "Delno", "Da"))
#vrstni red odgovorov
ggplot(anketa_fin,
       aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  theme(legend.position = "right") +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4)

#funkcija - ponavljanje
zamenjaj <- function(vektor, obstojece, nove){
  nov_vektor <- vector("logical", length = length(vektor))
  for(i in 1:length(obstojece)){
    nov_vektor[vektor == obstojece[i]] <- nove[i]
  }
  return(nov_vektor)
}
#primer
zamenjaj(c(1,2,3,1,3,2,2,1,2), c(1,2,3), c("a", "b", "c"))

unique(anketa_fin$Vprasanje)
opisi <- zamenjaj(anketa_fin$Vprasanje, unique(anketa_fin$Vprasanje),
                  c("Too far from my home",
                    "Lack of good transportation links",
                    "Poor quality of space",
                    "Functional disability",
                    "Lack of time",
                    "Financial reasons",
                    "I don't have company for PA",
                    "I am too tired for such activities",
                    "Lack of motivation"))
anketa_fin$Vprasanje <- opisi

#novi opisi
ggplot(anketa_fin, aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  theme(legend.position = "right") +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4)

library(stringr)

str_wrap("Ta stavek je dokaj dolg!", width = 10)

#delimo vrstice
ggplot(anketa_fin, aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  theme(legend.position = "right") +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4) +
  scale_x_discrete(labels = function(x) {str_wrap(x, width = 15)}) +
  theme(axis.text.x = element_text(size = 8))

#premaknemo legendo
ggplot(anketa_fin, aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  theme(legend.position = c(1.01, 0.98),
        legend.justification = c(0, 1)) +
  theme(plot.margin = margin(0, 4.5, 0, 0, "cm")) +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4) +
  scale_x_discrete(labels = function(x) {str_wrap(x, width = 15)}) +
  theme(axis.text.x = element_text(size = 8))

#dodamo poljubne barve
ggplot(anketa_fin, aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  theme(legend.position = c(1.01, 0.98),
        legend.justification = c(0, 1)) +
  theme(plot.margin = margin(0, 4.5, 0, 0, "cm")) +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color="white",
            size=4) +
  scale_x_discrete(labels = function(x) {str_wrap(x, width = 15)}) +
  theme(axis.text.x = element_text(size = 8)) + 
  scale_fill_manual(values = c("burlywood",#lahko po imenih(blizu (224, 189, 141))
                               rgb(15, 207, 201, maxColorValue = 255),
                               rgb(0, 101, 128, maxColorValue = 255),
                               "#871F5D"))

#dodamo barve teksta
ggplot(anketa_fin, aes(x = reorder(Vprasanje, ord), y = Stevilo, fill = Odgovor)) +
  geom_bar(stat = "identity") +
  #belo ozadje
  theme_bw() +
  ylab("Respondent Count") +
  xlab("") +
  theme(legend.position = c(1.01, 0.98),
        legend.justification = c(0, 1)) +
  theme(plot.margin = margin(0, 4.5, 0, 0, "cm")) +
  #Dodamo tekst na graf
  geom_text(aes(label=Stevilo),
            position = position_stack(vjust = 0.5),
            color=zamenjaj(anketa_fin$Odgovor, c("Zame ne velja", "Ne", "Delno", "Da"),
                           c("black", "black", "white", "white")),
            size=4) +
  scale_x_discrete(labels = function(x) {str_wrap(x, width = 15)}) +
  theme(axis.text.x = element_text(size = 8)) +
  scale_fill_manual(values = c("burlywood",#lahko po imenih(blizu (224, 189, 141))
                               rgb(15, 207, 201, maxColorValue = 255),
                               rgb(0, 101, 128, maxColorValue = 255),
                               "#871F5D"))

# Organizacija podatkov in krajša analiza

data <- read.table("C:/delavnice/R-za-neprogramerje/Predavanje_08/data_raw/test_data.csv",
                   header = T,
                   dec = ".",
                   sep = ";",
                   quote = ""
)
head(data)

#1. Preveri Tm vrednosti in zavrzi vse podatke, ki imajo Tm vrednost izven območja 81.0-81.7.
#2. Za vsak vzorec preveri outlierje: če se Cq vrednost replikata razlikuje za >1 od mediane treh replikatov, jo zavrzi.
#3. Če ima vzorec vsaj dva pozitivna replikata, je pozitiven, sicer negativen.
#4. Izračunaj povprečno Cq za vse pozitivne vzorce.

## Rešitev 1

dim(data)

### Korak 1
step1 <- data[data$Tm >= 81.0 & data$Tm <= 81.7,]
dim(step1)

### Korak 2
step2 <- step1
step2$Cq <- as.numeric(step2$Cq)
step2 <- step2[!is.na(step2$Cq),]
dim(step2)

mediane <- aggregate(step2$Cq, by = list(step2$Sample), FUN = median, na.rm = T)
names(mediane) <- c("skupina", "mediana")
mediane

step2 <- merge(step2, mediane, by.x = "Sample", by.y = "skupina")
step2 <- step2[step2$mediana < step2$Cq + 1 & step2$mediana > step2$Cq - 1, ]
step2
### Korak 3

step3 <- step2
table(step3$Sample)

velikosti <- aggregate(step3$Sample, list(step3$Sample), FUN = length)
names(velikosti) <- c("Skupina", "n")
velikosti

step3 <- merge(step3, velikosti, by.x = "Sample", by.y = "Skupina")
step3 <- step3[step3$n > 1,]
step3

### Korak 4

step4 <- step3
povprecja <- aggregate(step4$Cq, list(step4$Sample), FUN = mean)
names(povprecja) <- c("Skupina", "Povprecje")
povprecja

step4 <- merge(step3, povprecja, by.x = "Sample", by.y = "Skupina")
step4

## Rešitev 2

### Korak 1

dataNA <- data
dataNA$Valid <- TRUE
dataNA$Valid <- dataNA$Tm >= 81.0 & dataNA$Tm <= 81.7
dataNA

### Korak 2

dataNA$Cq <- as.numeric(dataNA$Cq)
dataNA$Valid <- dataNA$Valid & !is.na(dataNA$Cq)
dataNA

mediane <- aggregate(dataNA$Cq[dataNA$Valid], by = list(dataNA$Sample[dataNA$Valid]), FUN = median, na.rm = T)
names(mediane) <- c("skupina", "mediana")
dataNA <- merge(dataNA, mediane, by.x = "Sample", by.y = "skupina", all = TRUE)
dataNA$Valid <- dataNA$Valid & (dataNA$mediana < dataNA$Cq + 1 & dataNA$mediana > dataNA$Cq - 1)
dataNA

### Korak 3

velikosti <- aggregate(dataNA$Sample[dataNA$Valid], list(dataNA$Sample[dataNA$Valid]), FUN = length)
names(velikosti) <- c("Skupina", "n")
dataNA <- merge(dataNA, velikosti, by.x = "Sample", by.y = "Skupina", all = TRUE)
dataNA$Valid <- dataNA$Valid & dataNA$n > 1
dataNA

### Korak 4

povprecja <- aggregate(dataNA$Cq[dataNA$Valid], list(dataNA$Sample[dataNA$Valid]), FUN = mean)
names(povprecja) <- c("Skupina", "Povprecje")
povprecja

dataNA <- merge(dataNA, povprecja, by.x = "Sample", by.y = "Skupina", all = T)
dataNA

unique(dataNA[, c("Sample", "Povprecje")])

## Rešitev 3

sin(c(1,2,3))
c(1,2,3) %>% sin()


library(dplyr)
data$Cq <- as.numeric(data$Cq) #tudi to bi lahko dodali v pipe
data %>%
  filter(Tm >= 81.0 & Tm <= 81.7) %>% #Korak 1
  group_by(Sample) %>% #Določimo, da želimo delati glede na Sample
  mutate(mediana = median(Cq, na.rm = T)) %>% #izračun median
  filter(mediana < Cq + 1 & mediana > Cq - 1) %>%#filtiranje outlierjev (Korak2)
  mutate(velikost = n()) %>% #Izračun velikosti
  filter(velikost > 1) %>% #Korak 3
  mutate(povprecje = mean(Cq)) %>% #Izračun povprečji (Korak 4)
  select(Sample, povprecje) %>% #Izberemo le dva stolpca
  unique() #Samo unikatne vrstice


# Avtomatsko generiranje kombinacij in shranjevanje slik
data("mtcars")
head(mtcars)

combn(names(data), 3)

test <- expand.grid(names(data), names(data), names(data))
head(test)

#plotly

library(ggtern)
ggtern(data=mtcars,aes(x=mpg,y=qsec, z=wt)) +
  geom_point()

#Če imate težave z namespace (methods)
#install.packages(installr)
#library("installr")
#updateR() #iz RGui - posodobi instalacijo R-ja

#install.packages("ggtern") #naložite še paket

kombinacije <- combn(names(mtcars), 3)
dim(kombinacije)
kombinacije <- t(kombinacije)
head(kombinacije) 

izrisi_ternarni_diagram <- function(stolpci, podatki){
  ggtern(data=podatki,aes_string(x = stolpci[1], y = stolpci[2],z = stolpci[3])) +
    geom_point()
}
izrisi_ternarni_diagram(c("mpg", "qsec", "wt"), mtcars)
izrisi_ternarni_diagram(c("mpg", "qsec", "disp"), mtcars)

shrani_ternarni_diagram <- function(stolpci, podatki){
  #izrisi graf in ga shrani
  slika <- ggtern(data=podatki,aes_string(x = stolpci[1], y = stolpci[2],z = stolpci[3])) +
    geom_point()
  #ustvari ime datoteke in jo shrani (lahko dodamo parametre)
  pot <- paste(getwd(),
               "./data_raw/ternarni_diagrami/",
               stolpci[1], "_",
               stolpci[2], "_",
               stolpci[3], "_",
               ".png", sep = "")
  print(pot)
  ggsave(pot, slika)
}
#test shranjevanja ene slike
shrani_ternarni_diagram(c("mpg", "qsec", "wt"), mtcars)
#generirano in shranimo vse slike
apply(kombinacije, 1, shrani_ternarni_diagram, podatki = mtcars)

# Osamelci - outliers

## Metode ostrega očesa

ggplot(mtcars, aes(x = wt)) + geom_histogram(bins = 10)

ggplot(mtcars, aes(y = wt)) + geom_boxplot()

boxplot(mtcars$wt)

boxplot.stats(mtcars$wt)$out

## Računske metode

range(mtcars$wt)

#top/bottom 2.5%
spodnja_meja <- quantile(mtcars$wt, 0.025)
zgornja_meja <- quantile(mtcars$wt, 0.975)

mtcars$wt[mtcars$wt < spodnja_meja | mtcars$wt > zgornja_meja]

### Hampfel filter
#median -+ 3MAD
median(mtcars$wt)
mad(mtcars$wt, constant = 1)
spodnja_meja <- mean(mtcars$wt) - 3*mad(mtcars$wt, constant = 1)
zgornja_meja <- mean(mtcars$wt) + 3*mad(mtcars$wt, constant = 1)

mtcars$wt[mtcars$wt < spodnja_meja | mtcars$wt > zgornja_meja]

## Statistične metode

### Grubbs test

library(outliers)
test <- grubbs.test(mtcars$wt) #Dodamo opposite = T, če želimo testirati min
test

### Dixton test

test <- dixon.test(mtcars[1:30,]$wt)
test

### Rosner test

library(EnvStats)
test <- rosnerTest(mtcars$wt, k = 2)
test

