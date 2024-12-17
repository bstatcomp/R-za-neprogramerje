#setwd("F:/r za neprogramerje/R-za-neprogramerje/Predavanje_08") #nastavite na svojo mapo

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

##linearna regresija
## --------------------------------------------------------------------------------------------------------
# Z linearno regresijo modelirajmo porabo goriva v odvisnosti od števila
# cilindrov, konjske moèi in teže. 
lr <- lm(mpg ~ cyl + hp + wt, data = mtcars)
summary(lr)


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
#install.packages("devtools")
#devtools::install_github("wilkelab/ungeviz")
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

## Tortni diagrami
## --------------------------------------------------------------------------------------------------------
#stevilo okužb na dan 23.11 po starostnih skupinah 
#pridobljenih iz covid-19 sledilnika
covid <- data.frame(Starosti = c("0-4","5-14", "15-24", "25-34", "35-44", 
                                 "45-54", "55-64", "65-76", "75-84", "85+"),  
                    Stevilo = c(80, 725, 334, 426, 637, 504, 352, 197, 91, 48))
#Starost mora biti faktor, da ohranimo zaporedje
covid$Starosti <- factor(covid$Starosti, levels = covid$Starosti, ordered = T) 

#Izraèunamo procente
#Za prikaz procentov števila zaokrožimo na cela stevila
covid$Procenti <- round(100*covid$Stevilo/sum(covid$Stevilo),0)

#Pripnemo znak za procent za labele
covid$Procenti_label <- paste(covid$Procenti, '%', sep = '')


ggplot(covid, aes(x="", y = Stevilo, fill=Starosti)) +
  geom_bar(stat="identity", width=1,  position = position_stack(reverse = TRUE)) +
  coord_polar("y", start=0) + theme_void() + 
  geom_text(aes(label = Procenti_label), 
            position = position_stack(vjust = 0.5, reverse=TRUE), 
            color = "white")

#..............................................................................
#Izberemo podatke, ki ustrezalo veè kot 5% deležu, ostale pobrišemo
covid$Procenti_label[covid$Procenti < 5] <- ""

ggplot(covid, aes(x="", y = Stevilo, fill=Starosti)) +
  geom_bar(stat="identity", width=1,  position = position_stack(reverse = TRUE)) +
  coord_polar("y", start=0) + theme_void() + 
  geom_text(aes(label = Procenti_label), 
            position = position_stack(vjust = 0.5, reverse=TRUE),  
            color = "white")

## Spreminjanje barv in oblikovanje grafov
## --------------------------------------------------------------------------------------------------------
library(RColorBrewer)
ggplot(covid, aes(x="", y = Stevilo, fill=Starosti)) +
  geom_bar(stat="identity", width=1,  position = position_stack(reverse = TRUE)) +
  coord_polar("y", start=0) + theme_void() + 
  geom_text(aes(label = Procenti_label), 
            position = position_stack(vjust = 0.5, reverse=TRUE),  
            color = "white") +
  scale_fill_brewer(palette="Spectral")

#scale_fill_manual(values = c("LightBlue", "Blue", "DarkBlue","LightGreen", 
#"Green", "DarkGreen","Black", 
#rgb(255, 128, 50, maxColorValue = 255), "#A6CEE3","#A6CEE3"))

ggplot(iris_longer, aes(x = Species, y = value, fill = name)) +
  geom_point(position = position_jitterdodge(),
             shape=23, 
             color="black",
             size=2.5) +
  scale_fill_brewer(palette = "Paired") +
  scale_y_continuous(breaks=c(0, 2, 4, 6, 8, 10), 
                     labels=c("low", "2", "4", "6", "8", "high"),
                     minor_breaks = c(4.5, 5, 5.5),
                     limits = c(0,10))

## Manjkajoèe vrednosti.
## --------------------------------------------------------------------------------------------------------
x <- c(4, 6, 1, NA, 5, NA, 6)

anyNA(x)

is.na(x[1])
is.na(x[4])

mean(x)

mean(x, na.rm = TRUE)
mean(x[!is.na(x)])

head(airquality)

head(na.omit(airquality))

df <- airquality
for(i in 1:ncol(df)){
  df[is.na(df[,i]), i] <- mean(df[,i], na.rm = TRUE)
}
head(df)


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

# Vizualizacija zemljevidov
## --------------------------------------------------------------------------------------------------------

library(maps)
svet <- map_data('world')
print(head(svet))

ggplot() +
  geom_polygon( data=svet, aes(x=long, y=lat, group=group),
                color="black", fill="lightblue" )

svet$long <- pmin(svet$long, 180)
ggplot() +
  geom_polygon( data=svet, aes(x=long, y=lat, group=group),
                color="black", fill="lightblue" ) +
  coord_map()


#......................................................................
slo <- "Slovenia"
slo.map <- map_data("world", region = slo)
head(slo.map)
postaje <- data.frame(Mesta = c("Ljubljana", "Celje", "Maribor", 
                                "Murska Sobota", "Nova Gorica", "Koper"), 
                      lat = c(46.0655, 46.23448, 46.55884, 
                              46.65148, 45.95551, 45.54297), 
                      long = c(14.5127,  15.26244, 15.65124, 
                               16.19175, 13.6524, 13.71354))

ggplot() +
  geom_path(data = slo.map, aes(x = long, y = lat)) +  
  geom_point(data=postaje, aes(x=long, y=lat), colour="Red",pch=1, size=2) +
  theme(legend.position = "none") + 
  geom_text(data = postaje, 
            aes(long, lat, label=Mesta),
            size=5, 
            vjust = 1) #vjust premakne napis, da ne pokriva toèke

#......................................................................
okolica <- c('Slovenia','Italy', 'Croatia', 'Austria', 'Hungary') 
okolica.map <- map_data("world", region = okolica)

#7-dnevno povpreèje v torek
covid_torek <- c(3106, 9866, 4615, 14004, 9435)
#prebivalci po državah
prebivalci <- c(2.1, 59.5, 4, 8.9, 9.8)
incidenca_tabela <- data.frame(Drzava = okolica, Incidenca = (covid_torek/prebivalci))
incidenca_tabela
#tabeli okolica.map dodamo prazen stolpec Incidence
okolica.map <- cbind(okolica.map, Incidenca=NA)
# Vnesemo incidence v tabelo okolica.map po državah
for (d in okolica){
  okolica.map[okolica.map$region == d, 'Incidenca'] <- 
    incidenca_tabela[incidenca_tabela$Drzava == d, 'Incidenca']
}

ggplot(data = okolica.map, aes(x = long, y = lat)) +
  geom_polygon(aes(group=group, fill=Incidenca))

# Bioconductor
## --------------------------------------------------------------------------------------------------------
if (!requireNamespace("BiocManager"))
  install.packages("BiocManager")

BiocManager::install()

#verzija paketa
packageVersion("BiocManager")
#verzija bioconductorja
BiocManager::version() 

BiocManager::install("QSutils")

browseVignettes("QSutils")

library(QSutils)

gene <- ReadAmplSeqs("./data_raw/nucleus_gene.fast", type="DNA")
gene$hseqs

# Izraèunamo razdalje med sekvencami
dist <- DNA.dist(gene$hseqs, pairwise.deletion = T, model = "K80")
# Hirarhièno gruèenje
clusters <- hclust(dist)
# Prikažemo razdalje z dendrogramom
plot(clusters)
# Na dendogramu obkrožimo štiri skupine
rect.hclust(clusters, k=4, border="red")


# Razdelimo na štiri skupine
cluster_ids <- cutree(clusters, k = 4)

#Pripravimo podatke v obliki tabele
podatki <- as.data.frame(cmdscale(dist)) #predstavimo podatke v 2d obliki
names(podatki) <- c("X", "Y")
podatki$Indeks <- as.factor(cluster_ids) #dodamo indekse

#Izrišemo  vzorce na graf 
ggplot(podatki, aes(x = X, y = Y, colour = Indeks)) +
  geom_point()

#...................................................................
filepath<-system.file("extdata","ToyData_RVReads.fna", package="QSutils")
sekvenca <- ReadAmplSeqs(filepath,type="DNA")
head(sekvenca$nr)
sekvenca$hseqs

Shannon(sekvenca$nr)
GiniSimpson(sekvenca$nr)

razdalje <- DNA.dist(sekvenca$hseqs,model="K80")
MutationFreq(razdalje)
NucleotideDiversity(razdalje)




## Browser.
## ---- eval = FALSE---------------------------------------------------------------------------------------
for (i in 1:10) {
  x <- 2 * i
  y <- x + 5
  if (y > 10) {
    browser()
  }
}

mnozi <- function(a, b){
  return(a*b)
}
deli <- function(a, b){
  return(a/b)
}
debug(deli) #oznaèimo funkcijo deli za razhrošèevanje
mnozi(2, 3) #se izvede normalno
deli(2, 3) #na prvi vrstici funkcije se poklièe browser()

undebug(deli)