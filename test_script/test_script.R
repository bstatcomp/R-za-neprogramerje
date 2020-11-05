setwd("C:/Users/Gregor/Documents/workshops/R-za-neprogramerje/test_script")
library("openxlsx")
library("ggplot2")
library("tidyr")

math_scores <- read.xlsx("./data_raw/student-performance.xlsx", 
                         sheet = "Math scores")
port_scores <- read.xlsx("./data_raw/student-performance.xlsx", 
                         sheet = "Portuguese scores")

math_longer <- pivot_longer(math_scores, cols = c("G1", "G2", "G3"))
ggplot(math_longer, aes(x = value)) +
  geom_bar() +
  facet_wrap(~ name)
ggsave("./moji_rezultati/primer-graf.png")

math_smaller <- math_scores[1:5, c(1:3, 9)]
port_smaller <- port_scores[1:5, c(1:3, 9)]

wb <- createWorkbook()
addWorksheet(wb, sheetName = "math smaller")
addWorksheet(wb, sheetName = "port smaller")
writeData(wb, sheet = "math smaller", math_smaller)
writeData(wb, sheet = "port smaller", port_smaller)
saveWorkbook(wb, "./moji_rezultati/primer-excel.xlsx", overwrite = TRUE)
