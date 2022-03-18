
setwd('/home/jana/git/R-za-neprogramerje/Predavanje_03/')

vek <- c(4, 2, 3, 6, 7, 1)
print(vek)

vek[4]
2 : 5
vek[2 : 5]
vek[c(2, 4, 6)]

vek[seq(2, 6, by = 2)]
vek[seq(6, 2, by = -2)]
##########################################

length(vek)
TRUE
FALSE
T
F
lv <- c(F, T, F, T, F, T)
print(lv)
vek[lv]

vek
po <- vek > 3
vek[po]
vek[vek > 3]

# > večje
# < manjše
# >=, <= 
# | ali
# & in 
# ! negiranje
# != ni enako
# == je enako

x <- c(1, 2, 5, 6, 3, 2, 2, 1)
x == 2

x == 2 | x == 3

x > 1 & x < 6

x != 5

x[x > 2 & x < 6]

which(x == 2)
x
############################################
visina <- c(179, 185, 183, 172, 174, 185, 193, 169, 173, 168)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "m", "f")
df <- data.frame(spol, visina, teza)
print(df)

dat <- read.table("./data_raw/president_county_candidate.csv",
                  header = TRUE, 
                  sep = ",",
                  quote = "")
dat
head(dat, 10)
tail(dat, 20)

dim(dat)
nrow(dat)
ncol(dat)
names(dat)

summary(dat)
###################################

df
df[ 3, ]
df[3 : 6, ]
df[ , 3]
df[ , 1:2]
df[ , c(1, 3)]
df[c(2, 4, 6), c(1, 3)]

df[ , "spol"]
df[ , c("spol" , "teza")]
df$spol

df
df[df$visina > 180, ]
df[df$spol == "f" & df$visina > 170, ]
df[df$spol == "f" & df$visina > 170, "teza"]
df[df$spol == "f" & df$visina > 170, ]$teza

df[df$visina > 185, ]

########

df[ , -2]
df[-3, ]
df[-c(1,3), ]
df[-(3:6), ]
df[-(3:6), -(1:2)]
df[-c(2, 4, 6), -c(1)]
df[ , -c("spol", "teza")]
#####################

imena <- c("Micka", "Marko", "Gregor", "Tomaz", "Ana", "Peter", "Mojca", "Katja",
           "Anze", "Alja")
length(imena)
df
df$imena <- imena
df

vrstica <- data.frame(spol = "m", visina = 170, teza = 60, imena = "Samo")
df[11, ] <- vrstica
df
df[nrow(df) + 1, ] <- vrstica
df

df <- df[-nrow(df), ]
df
df[15, ] <- vrstica
df
df <- df[-(12:15), ]
df
#######


names(df)
ind <- which(names(df) == "teza")
df[ , -ind]

mn1 <- names(df)
mn1

mn2 <- c("spol", "imena")
mn2

mnd <- setdiff(mn1, mn2)
mnd
df[ , mnd]
