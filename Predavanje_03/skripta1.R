setwd('/home/jana/delavnice/R-za-neprogramerje/Predavanje_03/')


vek <- c(4, 2, 3, 6, 7, 1)
vek[2]
2:5
vek[2:5]
vek[c(2, 4, 6)]
vek[c(1, 5, 10)]
seq(2, 6, by = 2)
2:6
vek[seq(2, 6, by = 2)]
vek[seq(6, 2, by = -2)]


######################logične spremenljivke

T
F
length(vek)
lv <- c(F, T, F, T, F, T)
vek[lv]

vek > 3
vek[vek > 3]
vek < 5
vek == 7
vek >= 4
vek <= 5
# | ali   & in

vek < 3 | vek > 5
vek > 3 & vek < 5
vek != 2

vek[vek< 3 | vek > 5]

a <- c(1, 3, NA, 5, NA, 4)
is.na(a)
a[is.na(a)] <- mean(a, na.rm = T)
a[is.na(a)] <- 1000
a

vek >= 6
which(vek >= 6)
################################data.frame
visina <- c(179, 185, 183, 172, 174, 185, 193, 169, 173, 168)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "f", "m")

length(visina)
length(teza)
length(spol)

df <- data.frame(spol, visina, teza)
df

dat <- read.table("./data_raw/president_county_candidate.csv",
                  header = T,
                  sep = ",",
                  quote = "")

dat
head(dat)
head(dat, 20)

tail(dat)
tail(dat, 15)
dim(dat)
nrow(dat)
ncol(dat)
names(dat)
summary(dat)

df
df[3, ]
df[ , 2]
df[ , 1:2]
df[ , c(1, 3)]
df[c(2, 4, 6), c(1, 3)]
names(df)
df[ , "spol"]
df[ , c("visina", "spol")]
df$visina
df[df$visina > 180, ]
#enakovredna ukaza
df[df$visina > 175 & df$spol == "f", "teza"]
df[df$visina > 175 & df$spol == "f", ]$teza


df[df$visina > 180, ]

df[ , -2]
df[-3, ]
df[-(3:6), ]
df[-(3:6), -(1:2)]
df[-c(2, 4, 6, 8, 10), -1]
df[ , -c("spol", "teza")]

dim(df)

imena <- c("Micka", "Marko", "Gregor", "Tomaz", "Ana", "Peter",
           "Mojca", "Katja", "Anze", "Alja")
length(imena)
df$imena <- imena
df

vrstica <- data.frame(spol = "m", visina = 170, teza = 60, imena = "Samo")
vrstica
df[11, ] <- vrstica
df

df[nrow(df) + 1, ] <- vrstica
df

df[-nrow(df), ]
df

df[2:5, c(1,3)]
df

df <- df[-nrow(df), ]
df


df[ , -c("spol", "teza")]
ind <- which(names(df) == "teza")
df[ , -ind]

df
df[ , c(4, 1, 2, 3)]


