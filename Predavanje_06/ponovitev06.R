setwd("/home/jana/git/R-za-neprogramerje/Predavanje_06")
library(openxlsx)
library(ggplot2)

podatki <- NULL

imena_listov <- getSheetNames("./data_raw/online-retail-large.xlsx")

for (i in imena_listov) {
  print(i)
  if (i == "Unspecified") {
    print("Izpuscam ponovitev.")
    next
  }
  podatki_tmp <- read.xlsx("./data_raw/online-retail-large.xlsx", sheet = i)
  podatki <- rbind(podatki, podatki_tmp)
}

podatki$Total_sales <- podatki$Quantity * podatki$UnitPrice

podatki_agg <- aggregate(x = podatki$Total_sales,
                         by = list(podatki$Country),
                         FUN = sum)

ggplot(podatki_agg, aes(x = Group.1, y = x)) +
  geom_bar(stat = "identity") +
  coord_flip()

# Tega se nismo zadnjic, lahko pa pokazes:
ggplot(podatki_agg, aes(x = reorder(Group.1, x), y = x)) +
  geom_bar(stat = "identity") +
  coord_flip()
