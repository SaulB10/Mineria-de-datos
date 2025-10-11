install.packages("arules")
install.packages("readxl")

library(arules)
library(readxl)

datos <- read_excel("C:\\Users\\saulb\\Downloads\\graduados-superior-2023.xlsx")

reglas <- apriori(datos, parameter = list(support = 0.2, confidence = 0.5))

inspect(reglas[0:130])

data.frame(1:ncol(datos), colnames(datos))
datos <- datos[, -1]
reglas_2 <- apriori(datos, parameter = list(support=0.2, confidence = 0.5)) 
inspect(reglas_2[0:44])

datos_masculino <- subset(datos, Sexo == "Hombre")
data.frame(1:ncol(datos_masculino), colnames(datos_masculino))
datos_masculino <- datos_masculino[, -3]
reglas_masculino <- apriori(datos_masculino, parameter = list(support = 0.2, confidence = 0.5))
info_hombre <- inspect(reglas_masculino[1:30])

datos_femenino <- subset(datos, Sexo == "Mujer")
data.frame(1:ncol(datos_femenino), colnames(datos_femenino))
datos_femenino <- datos_femenino[, -3]
reglas_femenino <- apriori(datos_femenino, parameter = list(support = 0.2, confidence = 0.5))
info_mujer <- inspect(reglas_femenino[1:30])

