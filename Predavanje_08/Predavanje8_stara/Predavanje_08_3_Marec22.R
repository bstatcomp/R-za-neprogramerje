#setwd("F:/projekti/RMar22/R-za-neprogramerje/Predavanje_08") #nastavite na svojo mapo
setwd("E:/pred8mar22/Predavanje_08") #nastavite na svojo mapo

# Modelirajmo porabo goriva, pri čemer kot neodvisne spremenljivke uporabimo:
# število cilindrov, konjsko moč in težo.
lr <- lm(mpg ~ cyl + hp + wt, data = mtcars)
summary(lr)

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

##linearna regresija
## --------------------------------------------------------------------------------------------------------
# Z linearno regresijo modelirajmo porabo goriva v odvisnosti od števila
# cilindrov, konjske moči in teže. 
lr <- lm(mpg ~ cyl + hp + wt, data = mtcars)
summary(lr)


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

##delo z grafi
## --------------------------------------------------------------------------------------------------------
#ponovitev 4 naloge petega tedna

df <- read.table("./data_raw/PM10mesta.csv", header = TRUE, sep=",", quote = "\"", dec = '.')
#spremenimo datum
df$Datum <- as.Date(df$Datum)

#Najprej naredimo izris samo za Ljubljano - ?rta
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") 
#Dodajmo sen?enje pod grafom in izbri?emo Datum na x-osi
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") +
  geom_area(alpha = 0.1, fill = "orange") + ylim(0, 100) +
  xlab("")
#Izberemo eno izmed ?e nastavljenih tem z ukazom theme_bw() - black/white theme
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") +
  geom_area(alpha = 0.1, fill = "orange") + ylim(0, 100) +
  xlab("") +
  theme_bw()

#Dodamo horzintalno ?rto za kriti?no vrednost
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") +
  geom_area(alpha = 0.1, fill = "orange") + ylim(0, 100) +
  xlab("") +
  theme_bw() +
  geom_hline(yintercept = 50, lty = "dashed", colour = "red")

#Dodamo to?ke na graf in premaknemo legendo na spodnjo stran
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") +
  geom_area(alpha = 0.1, fill = "orange") + ylim(0, 100) +
  xlab("") +
  theme_bw() +
  geom_hline(yintercept = 50, lty = "dashed", colour = "red") +
  geom_point(data = df[df$kraj == "Ljubljana",], 
            aes(colour = weekdays(Datum) == "sobota" | 
                  weekdays(Datum) == "nedelja")) +
  ggtitle("Vrednosti meritev PM10 za tri slovenska mesta.") +
  labs(color = "Vikend?") + 
  theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))

#kon?no naredimo izris za vsak kraj posebej
ggplot(df, aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") +
  geom_area(alpha = 0.1, fill = "orange") + ylim(0, 100) +
  xlab("") + 
  theme_bw() +
  geom_hline(yintercept = 50, lty = "dashed", colour = "red") + 
  geom_point(data = df, 
             aes(colour = weekdays(Datum) == "sobota" | 
                   weekdays(Datum) == "nedelja")) +
  ggtitle("Vrednosti meritev PM10 za tri slovenska mesta.") +
  labs(color = "Vikend?") + 
  theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) +
  facet_wrap(. ~ kraj, ncol = 1)

## --------------------------------------------------------------------------------------------------------
# Vzorci in slike na grafih
d <- aggregate(x = df$PM10, by = list(df$kraj), FUN = sum, na.rm = TRUE)
names(d) <- c("mesto", "povprecje")
d
ggplot(d, aes(x = mesto, y = povprecje)) +
  geom_bar(stat = "identity")

#dodajmo vzorec
#install.packages("ggpattern")
library(ggpattern)
#potrebno je uporabiti 'pattern' verzijo eg geom_bar_pattern
ggplot(d, aes(x = mesto, y = povprecje)) +
  geom_bar_pattern(stat = "identity")
#lahko uporabime izbrane vzorce (stripe, crosshatch, point, circle, none)
ggplot(d, aes(x = mesto, y = povprecje)) +
  geom_bar_pattern(stat = "identity", aes(fill = mesto, pattern = mesto, 
                                          pattern_fill = "green"),
                   pattern = c("crosshatch", "circle", "stripe"),
                   pattern_fill = "orange",
                   pattern_colour = "lightgrey")

#dodajmo vzorec doma?i nalogi
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10)) + 
  geom_line(colour = "black") +
  geom_area_pattern(alpha = 0.1, fill = "orange", pattern = "crosshatch", pattern_alpha = 0.5) + ylim(0, 100) +
  xlab("") + 
  theme_bw() +
  geom_hline(yintercept = 50, lty = "dashed", colour = "red") + 
  geom_point(data = df[df$kraj == "Ljubljana",], 
             aes(colour = weekdays(Datum) == "sobota" | 
                   weekdays(Datum) == "nedelja")) +
  ggtitle("Vrednosti meritev PM10 za tri slovenska mesta.") +
  labs(color = "Vikend?") + 
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
## --------------------------------------------------------------------------------------------------------
#dodajanje slik
#install.packages("ggimage")
library(ggimage)
#slikica na vrhu
ggplot(d, aes(x = mesto, y = povprecje, image="./img/small.png")) +
  geom_bar(stat = "identity") + geom_image()

#da zamenjamo vzorec s sliko je nekoliko težje

vzorci <- c("./img/kamen.png",
            "./img/cloud.png",
            "./img/small.png")
  
ggplot(d, aes(x = mesto, y = povprecje)) +
  geom_bar_pattern(stat = "identity", 
                   aes(pattern_filename = mesto),
                   pattern = "image") +
  scale_pattern_filename_discrete(choices = vzorci)

#raz?irimo, da se lepše prilagaja
ggplot(d, aes(x = mesto, y = povprecje)) +
  geom_bar_pattern(stat = "identity", 
                   aes(pattern_filename = mesto),
                   pattern = "image",
                   pattern_type    = 'tile',
                   pattern_filter  = 'box',
                   pattern_scale   = -1) +
  scale_pattern_filename_discrete(choices = vzorci)

## --------------------------------------------------------------------------------------------------------
#extra
#dodajmo poljuben vzorec domači nalogi
ggplot(df[df$kraj == "Ljubljana",], aes(x = Datum, y = PM10, pattern_filename = 1)) + 
  geom_line(colour = "black") +
  geom_area_pattern(alpha = 0.1,
                    pattern = "image", 
                    pattern_alpha = 0.5,
                    pattern_type = "tile",
                    pattern_scale = -1) + 
  scale_pattern_filename_continuous(choices = "./img/small.png") +
  ylim(0, 100) +
  xlab("") + 
  theme_bw() +
  geom_hline(yintercept = 50, lty = "dashed", colour = "red") + 
  geom_point(data = df[df$kraj == "Ljubljana",], 
             aes(colour = weekdays(Datum) == "sobota" | 
                   weekdays(Datum) == "nedelja")) +
  ggtitle("Vrednosti meritev PM10 za tri slovenska mesta.") +
  labs(color = "Vikend?") + 
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) 
#extra
          
## --------------------------------------------------------------------------------------------------------
#Dodajmo še črto povprečja
ggplot(d, aes(x = mesto, y = povprecje)) +
  geom_bar_pattern(stat = "identity", 
                   aes(pattern_filename = mesto),
                   pattern = "image",
                   pattern_type    = 'tile',
                   pattern_filter  = 'box',
                   pattern_scale   = -1) +
  scale_pattern_filename_discrete(choices = vzorci)+
  geom_hline(yintercept = mean(d$povprecje), color="blue")


## --------------------------------------------------------------------------------------------------------
##Branje specifičnih tekstovnih datotek
library(stringr)

fl <- file("./data_raw/VZOREC ODMERNI SEZNAM DOBICEK.txt", "r")
dat <- readLines(fl)


preberi_stran <- function(stran){
  glava <- grep(pattern = "---", x = stran)
  # Locimo podvojene vrstce
  vrstice_1 <- stran[seq(from = glava[2]+1, to = length(stran)-2, by = 2)]
  vrstice_2 <- stran[seq(from = glava[2]+2, to = length(stran)-1, by = 2)]
  
  # Popravimo prve vrstico
  vrstice_1 <- str_squish(vrstice_1) # odstranemo odvecne presledke
  # locimo glede na presledke, pustimo neurejeno zadnjo kolono
  vrstice_1 <- str_split(vrstice_1, " ", simplify = T,n = 4)
  # popravimo zadnjo kolono, locimo glede na vejico in pustimo neurejeno zadnjo
  vrstice_1 <- cbind(vrstice_1[, -4], str_split(vrstice_1[, 4], ",", simplify = T, 2))
  # locimo preostale stolpce  in ohranimo locilo (oprostitev ali izguba)
  tmp <- str_split(vrstice_1[, 5], "Oprostitev|Izguba", simplify = T,  n =2)
  tmp2 <- str_match(vrstice_1[, 5], "Oprostitev|Izguba")
  # zdruzimo skupaj
  vrstice_1 <- cbind(vrstice_1[, -5], tmp[, 1], tmp2, tmp[, -1])
  vrstice_1 <- as.data.frame(vrstice_1)
  colnames(vrstice_1) <- c("St", "st_odmere", "davcna", "naslovnik", "naslovnik_naslov", "odmera", "odmerjeni_davek")
  
  vrstice_2 <- str_squish(vrstice_2) # odstranemo odvecne presledke
  tmp <- str_split(vrstice_2, "\\d+", simplify = T, 4)[, 2:3] # Izvozimo tekstovne stoplce
  tmp2 <- str_split(vrstice_2, "\\D+", simplify = T, 4)[,1:2] # Izvozimo numericne stolpce
  vrstice_2 <- cbind(tmp2[,1], tmp[,1], tmp2[,2], tmp[,2])
  vrstice_2 <- as.data.frame(vrstice_2)
  colnames(vrstice_2) <- c("st_odlocbe","naslovnik_kraj", "naslovnik_posta_st", "naslovnik_posta")
  return(cbind(vrstice_1, vrstice_2))
}

dokument <-NULL
# iteriramo skozi vse strani
strani <- c(1, grep("===", dat), length(dat))
for (i in 1:(length(strani)-1)){
  tmp <- preberi_stran(dat[strani[i]:strani[i + 1]])
  dokument <- rbind(dokument, tmp)
}

#preuredimo stolpce
dokument <- dokument[, c(1, 2, 8, 3, 4, 5, 9, 10, 11, 6,7 )]
dokument

## --------------------------------------------------------------------------------------------------------
#časovne vrste
library(forecast)
#glajenje(7 dnevno povprečje) in arima

delci <- read.csv("./data_raw/delci2.csv")
delci$Datum <- base::as.Date(delci$Datum, format = c("%m/%e/%Y"))
delci$Datum

library(zoo)
okna <- rollmean(delci$PM10, k = 7, fill = 'NA')

ggplot(delci, aes(x = Datum, y = PM10)) +
  geom_line(color = "lightblue") +
  geom_line(color = "red", aes(y = rollmean(PM10, k = 7, fill = 'NA'))) + 
  geom_line(color = "darkgreen", aes(y = rollmax(PM10, k = 7, fill = 'NA'))) +
  geom_line(color = "darkgreen", aes(y = rollapply(PM10, width = 7, FUN = min, fill = 'NA')))

#zalika od prejĹˇnjega dne
ggplot(delci, aes(x = Datum, y = PM10 )) +
  geom_line(color = "lightblue") +
  geom_line(color = "red", aes(y = c(0,diff(PM10)))) 


## --------------------------------------------------------------------------------------------------------
#forcasts
library(forecast) #auto.arima
#https://otexts.com/fpp2/arima-r.html#fig:ee1


ggtsdisplay(diff(delci$PM10), main = "") #suggest arima 7

fit <- arima(delci$PM10, order = c(7, 1, 0))

checkresiduals(fit)

autoplot(forecast(fit))


fit <- auto.arima(delci$PM10)
autoplot(forecast(fit))

## --------------------------------------------------------------------------------------------------------
#strojno učenje

head(iris)

ggplot(iris, aes(x = Petal.Width, y = Petal.Length, colour = Species)) +
  geom_point()

linearni_model <- lm(Species ~ ., iris)
linearni_model
## --------------------------------------------------------------------------------------------------------
#deljenje podatkov na uÄŤno in testno mnoĹľico
set.seed(1234)
sel <- sample(1:nrow(iris), 20, F)
train <- iris[-sel,]
test <- iris[sel,]

train
test
## --------------------------------------------------------------------------------------------------------
#veÄŤinski klasifikator
table(train$Species)


maj_class <- "virginica"
sum(test$Species == maj_class) / length(test$Species)

#linearni model
linearni_model <- lm(Petal.Width ~ Petal.Length + Sepal.Width + Sepal.Length, train)
linearni_model
napovedi <- predict(linearni_model, test)

## --------------------------------------------------------------------------------------------------------
mae <- function(obs, pred){
  mean(abs(obs - pred))
}

# srednja kvadratna napaka
mse <- function(obs, pred){
  mean((obs - pred)^2)
}
# relativna srednja kvadratna napaka
rmse <- function(obs, pred, mean.val){  
  sum((obs - pred)^2)/sum((obs - mean.val)^2)
}
## --------------------------------------------------------------------------------------------------------

mae(test$Petal.Width, napovedi)
mse(test$Petal.Width, napovedi)
rmse(test$Petal.Width, napovedi, mean(train$Petal.Width))

## --------------------------------------------------------------------------------------------------------
#nakljuÄŤno drevo
library(randomForest)

#regresija
rf <- randomForest(Petal.Width ~ Petal.Length + Sepal.Width + Sepal.Length, 
                   data = train)
napovedi <- predict(rf, test)
mae(test$Petal.Width, napovedi)
mse(test$Petal.Width, napovedi)
rmse(test$Petal.Width, napovedi, mean(train$Petal.Width))

## --------------------------------------------------------------------------------------------------------
#klasifikacija
rf <- randomForest(Species ~ ., 
                   data = train)
napovedi_r <- predict(rf, test, type = "class")
napovedi_v <- predict(rf, test, type = "prob")
napovedi_r
napovedi_v

sum(test$Species == napovedi_r) / length(test$Species)
rbind(test$Species, napovedi_r)



