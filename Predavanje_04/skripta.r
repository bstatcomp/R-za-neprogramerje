setwd("/home/jana/git/R-za-neprogramerje/Predavanje_04")
visina <- c(179, 185, 183, 172, 174, 185, 193, 169, 173, 168)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "m", "f")
imena <- c('Micka', 'Marko', 'Gregor', 'Tomaz', 'Ana', 'Peter',
           'Mojca', 'Katja', 'Anze', 'Alja')
df <- data.frame(spol, visina, teza, imena)
print(df)

df[3, ]
df[ , 2]
df[ , "teza"]
df[df$visina > 170, ]

df[-2, ]
df[ , -1]
df[ , -which(names(df) == "teza")]
###################################
3 / 7
q <- 300
q/ 3

df$visina /100
df$teza/(df$visina/100)^2
df$BMI <- df$teza/(df$visina/100)^2

df$visina + df$spol
df[1, ] + df[2, ]
df$visina + df$teza
df$visina + 5
log(df$visina)


dat <- read.table("./data_raw/delci2.csv", header = TRUE, sep=",", quote = "\"", dec = '.')
summary(dat)

mean(dat$PM10)
median(dat$PM10)

dat$kraj
vek <- c(8, 8, 8, 9, 9, 9, 9 , 7, 7, 2)
unique(vek)
unique(dat$kraj)
datPM10 <- dat[dat$kraj == "Celje" & dat$PM10 > 30, ]
head(datPM10, 10)
summary(datPM10)

datPM10$PM10err <- datPM10$PM10 * 0.22
head(datPM10, 10)
datPM10$PM10corr <- datPM10$PM10 + datPM10$PM10err
head(datPM10, 10)
datPM10$NaCl <- datPM10$Na + datPM10$Cl
head(datPM10, 10)

write.table(datPM10, './data_clean/delci_popravljeni.csv', sep = ",", dec = ".", row.names=F)
min(dat$PM10)
max(dat$Ca)

mn <- setdiff(names(datPM10), c('Datum', 'kraj'))
datPM10n <- datPM10[, mn]
head(datPM10n)

apply(datPM10n, 2, max)
apply(datPM10n, 2, min)
apply(datPM10n, 2, mean)
apply(datPM10n, 2, sum)

datPM10brez <- datPM10n[ , setdiff(names(datPM10n), c("PM10err" ,
                                                      "PM10corr", "NaCl" ))]
head(datPM10brez, 10)

datPM10$PM10total <- apply(datPM10brez, 1, sum)
head(datPM10,10)

############################
as.Date("2020-02-01")

as.Date(datPM10$Datum)
as.Date(datPM10$Datum, format = "%m/%d/%y")
summary(datPM10)
datPM10$Datum <- as.Date(datPM10$Datum, format = "%m/%d/%y")
summary(datPM10)

library(lubridate)
day(datPM10$Datum)
month(datPM10$Datum)
year(datPM10$Datum)
yday(datPM10$Datum)
weekdays(datPM10$Datum)

datPM10[month(datPM10$Datum) == 11, ]

datPM10[month(datPM10$Datum) >= 9 & 
          month(datPM10$Datum) <=11, ]


mn1 <- names(df)
mn3 <- c("spol", "imena", "starost", "st_noge")
union(mn1, mn3)
union(mn3, mn1)

intersect(mn1, mn3)
intersect(mn3, mn1)

setdiff(mn1, mn3)
setdiff(mn3, mn1)

