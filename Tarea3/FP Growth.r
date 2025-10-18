install.packages("arules")
install.packages("pkgbuild")

library(readxl)
library(arules)
library(pkgbuild)

data <- read_excel("C:\\Users\\saulb\\Downloads\\base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx")

data_fp <- data[, c("HEC_MES", "HEC_DEPTO", "VIC_EDAD", "VIC_ESCOLARIDAD", "VIC_EST_CIV", "VIC_GRUPET", "VIC_TRABAJA", "VIC_DEDICA")]

reglas_fp <- fim4r(data_fp, method="fpgrowth", target="rules", supp=0.2, conf=0.5)

rf <- as(reglas_fp, "data.frame")
head(rf)
