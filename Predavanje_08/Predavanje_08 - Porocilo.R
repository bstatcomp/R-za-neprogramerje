# toy dataset
height <- c(171, 185, 165, 190, 152)
weight <- c(70, 78, 64, 95, 67)
sex    <- c("m", "m", "z", "m", "z")
name   <- c("Alen", "Bojan", "Cvetka", "Dejan", "Eva")
age    <- c(41, 35, 28, 52, 22)
df     <- data.frame(Ime = name, 
                     Visina = height, 
                     Teza = weight, 
                     Spol = sex, 
                     Starost = age)


for (i in 1:nrow(df)) {
  oseba <- df[i,]
  rmarkdown::render("Predavanje_08 - Porocilo.Rmd", 
                    output_file = paste0("./porocila/oseba_", i, ".pdf"),
                    output_format = "pdf_document")
}



