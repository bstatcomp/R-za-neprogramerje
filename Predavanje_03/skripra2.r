vek <- c(4, 2, 3, 6, 7, 1)
vek[4]
vek[2:5]
vek[c(2, 4, 6)]
vek[seq(2, 6, by = 2)]

vek[seq(6, 2, by = -2)]

lv <- c(F, T, F, T, F, T)
vek[lv]

po <- vek > 3
print(po)
vek[po]
x <- c(1, 2, 5, 6, 3, 2, 2, 1)
x == 2

setwd('/home/jana/git/R-za-neprogramerje/Predavanje_03/')

dat <- read.table("./data_raw/president_county_candidate.csv", 
                  header = TRUE,
                  sep = ',',
                  quote = "")
head(dat)
summary(dat)
