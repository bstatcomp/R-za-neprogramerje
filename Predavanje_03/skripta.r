setwd("/home/jana/git/R-za-neprogramerje/Predavanje_03")

vek <- c(3, 4, 5, 2, 7, 3)
vek[4]
vek[2:5]
vek[c(2, 4, 6)]
seq(2, 6, by=2)
vek[seq(2, 6, by=2)]
vek[seq(6, 2, by=-2)]

##drugi način indeksiranja
lv <- c(F, T, F, T, F, T)
vek[lv]
vek[c(F, T, F, T, F, T)]
po <- vek > 3
vek[po]

x <- c(1, 2, 5, 6, 3, 2, 2, 1)
x == 2
x >= 3
x == 2 | x == 3
x > 1 & x < 6
x != 5
x[x > 1 & x < 6]

which(x == 2)
x[x > 1 & x < 6]

#####data.frame

visina <- c(179, 185, 183, 172, 174, 185, 193, 169, 173, 168)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "m", "f")
df <- data.frame(spol, visina, teza)

visina <- c(179, 185, 183, 172, 174, 185, 193, 169)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "m")
df <- data.frame(spol, visina, teza)

dat <- read.table("./data_raw/president_county_candidate.csv", header=TRUE, sep =",")

head(dat)
head(dat, 20)
tail(dat, 20)

dim(dat)
nrow(dat)
ncol(dat)
summary(dat)

#df[vrstice, stolpci]
df[3, ]
df[3:6, ]
df[ , 3]
df[ , 1:2]
df[ , c(1, 3)]
df[c(2, 4, 6), c(1, 3)]

df[df$visina > 180, ]
df[df$visina > 175 & df$spol == "f", "teza"]
df[df$visina > 175 & df$spol == "f", ]$teza
df[df$visina > 180, ]


df2 <- df[ , -2]

df[-3, ]
df[-(3:6), ]
df[-(3:6), -(1:2)]
df[-c(2, 4, 6), -1]

df[ , -c("spol", "teza")]

ind <- which(names(df) == "teza")
df[ , -ind]
df[ , -which(names(df) == "teza")]

mn1 <- names(df)
mn2 <- c("spol", "teza")

mnd <- setdiff(mn1, mn2)

imena <- c("Micka", "Marko", "Gregor", "Tomaz", "Ana", "Peter", "Mojca", 
           "Katja", "Anze", "Alja")
df$imena <- imena

vrstica <- data.frame(spol = "m", visina = 170, teza = 60, imena = "Samo")
df[11, ] <- vrstica
df[nrow(df) + 1, ] <- vrstica

df <- df[-nrow(df), ]

vrstica2 <- data.frame(spol = "f", visina = 163, teza = 55, imena = "Sara")

st_nog <- c(38, 42, 44, 43, 39, 42, 38, 40, 45, 37, 41)
df$stevilka_noge <- st_nog
df$stev_noge <- st_nog

#odstranimo stolpec stev_noge

df[ , -ncol(df)]
df <- df[ , -which(names(df) == "stev_noge")]


setwd("C:/Users/Gregor/Documents/shared_files/workshops/R-za-neprogramerje/Predavanje_03")
dat <- read.table("./data_raw/president_county_candidate.csv", header=TRUE, sep=",")
dat <- read.table("./data_raw/president_county_candidate.csv", header=TRUE, sep=",", quote = "")



