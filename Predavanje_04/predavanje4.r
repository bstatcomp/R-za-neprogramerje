setwd('/home/jana/git/R-za-neprogramerje/Predavanje_04/')

visina <- c(179, 185, 183, 172, 174, 185, 193, 169, 173, 168)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "m", "f")
imena <- c("Micka", "Marko", "Gregor", "Tomaz", "Ana", "Peter", 
           "Mojca", "Katja", "Anze", "Alja")
df <- data.frame(imena, spol, visina, teza)
df
#######ponovitev
df[1, 2]
df[3:5, ]
df[c(4, 6), ]
df[ , 'visina']
df$visina
df$visina > 170
df[df$visina > 170, ]
#############

#indeks telesne mase teza/visina (v m)^2

df$teza/ (df$visina/100)^2
df$ITM <- df$teza/ (df$visina/100)^2

df$visina + df$spol
df[1, ] + df[2, ]

df$visina + 5
df$visina/100
log(df$teza)
#################################

dat <- read.table('./data_raw/delci2.csv', 
                  header = TRUE,
                  dec = '.',
                  sep = ',',
                  quote = '\"')
head(dat, 5)
summary(dat)

vek <- c(8, 8, 8, 8, 9, 9, 9, 7, 7, 7, 2)
unique(vek)

unique(dat$kraj)

datPM10_Celje <- dat[dat$kraj == 'Celje' & dat$PM10 > 30, ]
unique(datPM10_Celje$kraj)

datPM10_Celje$PM10err <- datPM10_Celje$PM10 * 0.22
head(datPM10_Celje)
summary(datPM10_Celje)

datPM10_Celje$PM10corr <- datPM10_Celje$PM10 + datPM10_Celje$PM10err
head(datPM10_Celje)

write.csv(datPM10_Celje, './data_clean/delci_popravljeni.csv')
#####################################

max(datPM10_Celje$Ca)
min(datPM10_Celje$Ca)

#funkcija apply()

names(datPM10_Celje)
setdiff(names(datPM10_Celje), c('Datum', 'kraj'))
datPM10n <- datPM10_Celje[ , setdiff(names(datPM10_Celje), c('Datum', 'kraj'))]
head(datPM10n)
#1 izberem vrstice, 2 izberem stolpce
apply(datPM10n, 2, max)
apply(datPM10n, 2, min)
pov <- apply(datPM10n, 2, mean)
apply(datPM10n, 2, sum)

datPM10_Celje$PM10total <- apply(datPM10n, 1, sum)
head(datPM10_Celje)

#########DATUMI
as.Date("2020-02-01")
datPM10_Celje$Datum <- as.Date(datPM10_Celje$Datum, format = "%m/%d/%y")

library(lubridate)
day(datPM10_Celje$Datum)
month(datPM10_Celje$Datum)
year(datPM10_Celje$Datum)
yday(datPM10_Celje$Datum)
weekdays(datPM10_Celje$Datum)

datPM10_Celje[month(datPM10_Celje$Datum) == 11, ]
datPM10_Celje[month(datPM10_Celje$Datum) >= 9 & month(datPM10_Celje$Datum) <= 11, ]

#########Mnozice
mn1 <- names(df)

mn3 <- c('spol', 'teza', 'imena', 'starost', 'st_noge')

union(mn1, mn3)
union(mn3, mn1)
##########
intersect(mn1, mn3)
intersect(mn3, mn1)

setdiff(mn1, mn3)
setdiff(mn3, mn1)
