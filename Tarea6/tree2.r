# ------------------------------------------
#   INSTALACIÓN Y CARGA DE PAQUETES
# ------------------------------------------
install.packages("arules")
install.packages("genero")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("randomForest")

library(arules)
library(genero)
library(rpart)
library(rpart.plot)
library(randomForest)

# ------------------------------------------
#   CARGA Y LIMPIEZA DE DATOS
# ------------------------------------------
data <- read.csv("C:\\Users\\saulb\\Downloads\\dataarbol.csv",
                 fileEncoding = "latin1")
# -----------------------------------------------------
# PREPARACIÓN DE VARIABLES
# -----------------------------------------------------

# Convertir VIC_ESCOLARIDAD a factor (variable a predecir)
data$VIC_ESCOLARIDAD <- as.factor(data$VIC_ESCOLARIDAD)

# Convertir columnas útiles
data$VIC_EDAD       <- as.numeric(data$VIC_EDAD)
data$VIC_SEXO       <- as.factor(data$VIC_SEXO)
data$VIC_GRUPET     <- as.factor(data$VIC_GRUPET)
data$VIC_EST_CIV    <- as.factor(data$VIC_EST_CIV)
data$VIC_TRABAJA    <- as.factor(data$VIC_TRABAJA)
data$VIC_NACIONAL   <- as.factor(data$VIC_NACIONAL)
data$HEC_AREA       <- as.factor(data$HEC_AREA)
data$HEC_DEPTO      <- as.factor(data$HEC_DEPTO)

# Dataset final para Random Forest
data_rf <- data[, c(
  "VIC_ESCOLARIDAD",  # variable a predecir
  "VIC_SEXO",
  "VIC_EDAD",
  "VIC_EST_CIV",
  "VIC_GRUPET",
  "VIC_TRABAJA",
  "VIC_NACIONAL",
  "HEC_AREA",
  "HEC_DEPTO"
)]

# Eliminar filas con NA
data_rf <- na.omit(data_rf)

# -----------------------------------------------------
# ENTRENAR RANDOM FOREST
# -----------------------------------------------------
set.seed(123)

modelo_rf <- randomForest(
  VIC_ESCOLARIDAD ~ .,
  data = data_rf,
  ntree = 300,
  importance = TRUE
)

print(modelo_rf)

# -----------------------------------------------------
# IMPORTANCIA DE VARIABLES
# -----------------------------------------------------
importance(modelo_rf)
varImpPlot(modelo_rf, main = "Importancia de Variables")

# -----------------------------------------------------
# GRÁFICO DE ERROR VS ÁRBOLES
# -----------------------------------------------------
plot(modelo_rf, main = "Error del Modelo vs Número de Árboles")

# -----------------------------------------------------
# HACER UNA PREDICCIÓN NUEVA
# -----------------------------------------------------
persona_nueva <- data.frame(
  VIC_SEXO = factor("2", levels = levels(data_rf$VIC_SEXO)),               # Mujer
  VIC_EDAD = 24,                                                          # Edad
  VIC_EST_CIV = factor("2", levels = levels(data_rf$VIC_EST_CIV)),        # Ej: 2 = Soltera
  VIC_GRUPET = factor("1", levels = levels(data_rf$VIC_GRUPET)),          # Ej: 1 = Ladino
  VIC_TRABAJA = factor("1", levels = levels(data_rf$VIC_TRABAJA)),        # Sí trabaja
  VIC_NACIONAL = factor("1", levels = levels(data_rf$VIC_NACIONAL)),      # Guatemalteca
  HEC_AREA = factor("1", levels = levels(data_rf$HEC_AREA)),              # Urbano
  HEC_DEPTO = factor("1", levels = levels(data_rf$HEC_DEPTO))             # Guatemala
)

# Predicción
predict(modelo_rf, persona_nueva)
