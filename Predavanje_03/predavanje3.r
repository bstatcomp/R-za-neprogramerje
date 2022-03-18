setwd('/home/jana/git/R-za-neprogramerje/Predavanje_03/')
# za Wins je C:\mapa\ ali C://

vek <- c(4, 2, 3, 6, 7, 1)
vek[4]
vek[2 : 5]
vek[c(2, 4, 6)] #argument je vektor indeksov
seq(2, 6, by = 2)
vek[seq(2, 6, 2)]
vek[seq(6, 2, by = -2)]

lv <- c(F, T, F, T, F, T)
vek[lv]
vek > 3
vek[vek > 3]

# x > je vecji
# x < je manjsi
# x == 1 ali je x enoko 1 (x = 1)
# >= x vecje ali enako
# <= manjse ali enako
# | Ali
# & In
# ! Negiramo
# != Ni enako

x <- c(1, 2, 5, 6, 3, 2, 2, 1)
x == 2
x >= 3
x == 2 | x >= 3
x > 2 & x < 5
x[x > 1 & x < 5]

################ DATE FRAME
visina <- c(179, 185, 183, 172, 174, 185, 193, 169, 173, 168)
teza <- c(75, 89, 70, 80, 58, 86, 73, 63, 72, 70)
spol <- c("f", "m", "m", "m", "f", "m", "f", "f", "m", "f")
df <- data.frame(spol, visina, teza)

dat <- read.table("./data_raw/president_county_candidate.csv",
                  header = TRUE,
                  sep = ',',
                  quote = "", 
                  stringsAsFactors = TRUE)

head(dat, 20) # prvih 20 vrstic
tail(dat, 20) #zadnjih 20 vrstic
dim(dat) # velikost st. vrstic st. stolpec
nrow(dat) # stevilo vrstic
ncol(dat) # stevilo stolpcev
names(dat) #imena stolpcev
summary(dat) #osnovne statistike

#########
df
df[3, ] # 3. vrstica
df[3:6, ] # 3 do 6 vrstica
df[ , 3] # 3 stolpec
df[ , 1:2]
df[ , c(1, 3)] # 1 in 3 stolpec
df[c(2, 4, 6), c(1, 3)]
df[ , "spol"]
df[ , c("spol", "teza")]
df$spol

df[df$visina > 175, ]
df[df$visina > 175 & df$spol == 'f', ]
df[df$visina > 175 & df$spol == 'f', 'teza']
df[df$visina > 175 & df$spol == 'f', ]$teza
df[df$visina > 180, ]

# prikaz z odstranjenimi vrsticami ali stolpci
df[ , -2] # odtrani 2 stolpec
df[-3 , ]#odstrani 3 vrstico
df[-(3:6), ] # odstranimo sekvenco od 3. do 6.
df[-(3:6), -(1:2)] # odstranimo od 3. do 6. vrstzice in 1,2 stolpec
df[-c(2, 4, 6), -1]
df[ , -c('spol', 'visina')]
df
dim(df)
imena <- c("Micka", "Marko", "Gregor", "Tomaz", "Ana", "Peter", 
           "Mojca", "Katja", "Anze", "Alja")
length(imena)
df$imena <- imena #df[ , "imena"] <- imena
vrstica <- data.frame(spol = "m", visina = 170, teza = 60, imena = "Samo")
dim(df)
df[11, ] <- vrstica
df[nrow(df) + 1, ]<- vrstica
df <- df[-nrow(df), ]

# odstranjevanje stolpca po imenu
ind_s <- which(names(df) == "teza")
df[ , -ind_s]
df[ , -which(names(df) == "teza")]

# odstranimo vec stolpcev po imenih
mn1 <- names(df)
mn1
mn2 <- c("spol", "imena")
mn2
mnd <- setdiff(mn1, mn2)
df[ , mnd]
