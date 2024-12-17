library(openxlsx)
imena_listov <- getSheetNames("./data_raw/online-retail.xlsx")

for (ime_lista in imena_listov) {
  podatki_tmp <- read.xlsx("./data_raw/online-retail.xlsx", sheet = ime_lista)
  
  # Shranimo vsoto števila prodanih izdelkov za vsak raèun (InvoiceNo)
  podatki_agg <- aggregate(x = podatki_tmp$Quantity,
                           by = list(podatki_tmp$InvoiceNo),
                           FUN = sum)
  colnames(podatki_agg) <- c("st_racuna", "st_izdelkov")
  
  # S tem klicem poženemo "Predavanje_08 - Porocilo.Rmd". Vse spremenljivke
  # ki se nahajajo v trenutni ponovitvi zanke, bodo dostopne tudi temu
  # dokumentu.
  rmarkdown::render("Predavanje_08 - Porocilo.Rmd", 
                    output_file = paste0("./porocila/drzava_", ime_lista, 
                                         ".docx"),
                    output_format = "word_document")
  rmarkdown::render("Predavanje_08 - Porocilo.Rmd", 
                    output_file = paste0("./porocila/drzava_", ime_lista, 
                                         ".pdf"),
                    output_format = "pdf_document")
  
}


