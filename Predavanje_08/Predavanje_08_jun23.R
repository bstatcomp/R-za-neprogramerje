setwd("C:/delavnice/dev/p8")

list.dirs()

list.dirs("./data_raw/podatki")

list.files("./data_raw/podatki")

datoteke <- dir("./data_raw/podatki", include.dirs = FALSE, recursive = TRUE)
datoteke

for(d in datoteke){
  #obdeljaj datoteko
}


pokosih <- strsplit("mapa1/mapa2/datoteka.txt", split = "/")
pokosih
pokosih <- unlist(pokosih)
pokosih[length(pokosih)]

substr("moj neznan niz znakov", 5, 9)

library(tidyverse)
?grep

grep("a", c("ah", "oh", "eh", "aha", "pa res"))
grepl("a", c("ah", "oh", "eh", "aha", "pa res"))

gregexpr("a", "banana")

gsub("a", "", c("ah", "oh", "eh", "aha", "pa res"))
gsub("[aeiou]", "", c("ah", "oh", "eh", "aha", "pa res"))
gsub("[^aeiou]", "", c("ah", "oh", "eh", "aha", "pa res"))


gsub("[0-9]+", "", "crk3in5tev1lk3")
gsub("[^0-9]+", "", "crk3in5tev1lk3")

datum <- gsub(".*([0-9]+-[0-9]+-[0-9]+).*","\\1","4-1-2012_S2B.txt")
datum
as.Date(datum, format = "%d-%m-%Y")
class(as.Date(datum, format = "%d-%m-%Y"))

as.Date(datum, format = "%d-%m-%Y") > as.Date("2013-1-1")
#izberimo vse z končnico .txt, ki vsebuje S2A a ne S2B in vsebuje datum Januar 2012
izbrane <- data.frame(file=character(), date=Date(), S2A=logical())
for(d in datoteke){
  print("--------------------------")
  print(d)
  #odstranimo mape
  d <- unlist(strsplit(d, split = "/"))
  d <- d[length(d)]
  print(d)
  #odstranimo .csv in datoteke z S2B
  if(grepl("\\.csv", d) | grepl("S2B", d)){
    print("Removing .csv or S2B")
    next
  }
  #preverimo ustrezne datume
  datum <- gsub(".*([0-9]+-[0-9]+-[0-9]+).*","\\1",d)
  datum <- as.Date(datum, format = "%d-%m-%Y")
  if(datum < as.Date("2012-1-31") & datum > as.Date("2012-1-1")){
    #če datum ustrza, shranimo v tabelo
    S2A <- grepl("S2A", d)
    izbrane <- rbind(izbrane, data.frame(d, datum, S2A))
  }
}
izbrane

#--------------------------------------------------------------------------
#analiza pajkov
#Nephila analyses

library(openxlsx)
data <- read.xlsx(
  xlsxFile = "./data_raw/Nephila_data.xlsx",
  sheet = 1)

head(data)

summary(data)

library(ggplot2)

#Female size vs. number of males

g1 <- ggplot(data, aes(x = Leg.length, y = Males, colour = Adult.female)) + geom_point() + xlab("Female patella+tibia length (microns)") + ylab("Number of males") + ggtitle("Female size vs. number of males")
g1

#library(ggpubr)

#g1 + stat_cor(method = "pearson", label.x = 3, label.y = 30)

g1 + stat_smooth(method = "lm", col = "red")

g1 + stat_smooth(method = 'loess', col = "blue")

g1 + stat_smooth(method = "loess")
                 
g1 + stat_smooth(method = "loess", method.args = list(degree = 1))



g1 + stat_smooth(method = "lm", col = "red") + 
  stat_smooth(method = 'loess', col = "blue") +
  stat_smooth(method = "loess")

#mixed models
#https://m-clark.github.io/mixed-models-with-R/random_intercepts.html#example-student-gpa

#korelacija
cor(data$Leg.length, data$Males)


corr <- cor(data[,c("Leg.length", "Males", "Kleptos", "Nearest.web", 
                "Above.ground", "Web.diameter")])
corr
library(corrplot)
corrplot(corr, method="circle")

model <- lm(Males ~ Kleptos + Nearest.web + Leg.length, data)
model
summary(model)

#poljubne funkcije
g1 + stat_smooth(method = "loess") +
  stat_function(fun = function(x){2*sin(x/1000)+x/1000-10}, 
                n = 1000, col = "purple")

#-------------------------------------------------------------------------
#škatla z brki - okvirji z ročaji

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

#heatmap
pod <- read.table('./data_raw/PM10_heat.csv', sep=',', header = T)
pod
pod_l <- pivot_longer(pod, cols = 2:7, names_to = "Meseci", values_to = "Koncentracije")
pod_l$Meseci <- factor(pod_l$Meseci, levels = c("Jan", "Feb", "Mar", "Apr", "Maj", "Jun"))
ggplot(pod_l, aes(Mesto, Meseci, fill= Koncentracije)) +
  geom_tile()

ggplot(pod_l, aes(Mesto, Meseci, fill= Koncentracije)) +
  geom_tile(linejoin = "bevel") + theme(legend.position = "none")


ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_tile(aes(fill = density))

ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_raster(aes(fill = density), interpolate = TRUE)

ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_raster(aes(fill = density), interpolate = TRUE) +
  scale_fill_gradient(low = rgb(0.1, 0.0, 0.5), 
                      high = rgb(0.8, 0, 0)) 

#primeri za grafiko
#https://girke.bioinformatics.ucr.edu/GEN242/tutorials/rgraphics/rgraphics/


#pixel way
df <- data.frame(vrednosti = seq(0, 5000000, by=10000), gen1 = rep(0,501), gen2 = rep(0, 501), gen3=rep(0, 501), gen4 = rep(0, 501), gen5= rep(0,501))
df$gen1[350:358] <- 1
df$gen2[300:310] <- 1
df$gen3[380:420] <- 1
df$gen4[250:270] <- 1
df$gen5[350:380] <- 1

df_l <- pivot_longer(df, cols=2:ncol(df), names_to = "geni", values_to = "vr")
df_l$vr <- factor(df_l$vr)
ggplot(df_l, aes(x = geni, y = vrednosti, color = vr)) + geom_point() + coord_flip()

#stolpični diagrami
blocks <- data.frame(
  gens = c(rep("genom1", 3), rep("genom2", 3), rep("genom3", 1), 
            rep("genom4", 3), rep("genom5", 7)),
  type = c("off", "on", "off", #genome1
            "off", "on", "off", #genome 2...
            "off",
            "off", "on", "off",
            "off", "on", "off", "on", "off", "on", "off"
            ),
  group = c(1:3, 1:3, 1, 1:3, 1:7),
  value = c(3500000, 80000, 5000000-3500000-80000,
             3000000, 30000, 5000000-3000000-30000,
             5000000,
             4800000, 45000, 5000000-4800000-45000,
             500000, 40000, 1000000, 100000, 1000000, 30000, 5000000-2670000)
)

blocks


ggplot(blocks, aes(gens, value, group = group)) +
  geom_col(aes(fill = type)) +
  coord_flip()

ggplot(blocks, aes(gens, value, group = group)) +
  geom_col(aes(fill = type), width = 0.3) +
  coord_flip() +
  theme(legend.position = "none")



#install.packages("Gviz")
#install.packages("GenomicRanges")
#pozor zahtevna
#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

#BiocManager::install("Gviz")


#based on
#http://www.sthda.com/english/wiki/gviz-visualize-genomic-data

library(Gviz)
library(GenomicRanges)
  #Load data : class = GRanges
data(cpgIslands)
cpgIslands

atrack <- AnnotationTrack(cpgIslands, name = "CpG")
plotTracks(atrack)

## genomic coordinates
gtrack <- GenomeAxisTrack()
plotTracks(list(gtrack, atrack))

#genome : "hg19" 
gen<-genome(cpgIslands)
#Chromosme name : "chr7"
chr <- as.character(unique(seqnames(cpgIslands)))
#Ideogram track
itrack <- IdeogramTrack(genome = gen, chromosome = chr)
plotTracks(list(itrack, gtrack, atrack))


#Load data
data(geneModels)
head(geneModels)
#Plot
grtrack <- GeneRegionTrack(geneModels, genome = gen,
                           chromosome = chr, name = "Gene Model")
plotTracks(list(itrack, gtrack, atrack, grtrack))


#nalaganje rasterskih slik

library(terra)
library(ggplot2)
library(dplyr)

describe('./img/cea.tif')

Slika <- terra::rast("./img/cea.tif")
summary(Slika)

slika_df <- as.data.frame(Slika, xy = TRUE)

head(slika_df)

summary(slika_df)

library(ggplot2)
ggplot() +
  geom_raster(data = slika_df , aes(x = x, y = y, fill = cea)) +
  scale_fill_viridis_c() +
  coord_quickmap()

#naredimo inverz

slika_df$cea <- 255 - slika_df$cea
library(ggplot2)
ggplot() +
  geom_raster(data = slika_df , aes(x = x, y = y, fill = cea)) +
  scale_fill_viridis_c() +
  coord_quickmap()

ggsave("./img/inverz.png")

writeRaster(terra::rast(slika_df), "./img/inverz.tif")

writeRaster(terra::rast(slika_df), "./img/inverz.tif", 
            wopt= list(gdal=c("COMPRESS=NONE"), datatype='INT1U'),
            overwrite = TRUE)


#izbrišimo pas
slika_df[slika_df$x > -20000 & slika_df$x < -15000,3] <- 0
 

ggplot() +
  geom_raster(data = slika_df , aes(x = x, y = y, fill = cea)) +
  scale_fill_viridis_c() +
  coord_quickmap()



#sen2r ----------------------------------------------------------

library(sen2r)
library(sf)
# potrebujete shape datoteko, da definirate območje
border = read_sf("./Ljubljana_border.shp")
sen2r()

images_list = s2_list(
  spatial_extent = border,
  time_interval = as.Date(c("2015-05-01", "2020-08-30")),
  max_cloud = 1
)

images_list = as.data.frame(images_list)
