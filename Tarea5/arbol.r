
install.packages("rpart")
install.packages("rpart.plot")
install.packages("caret")
install.packages("dplyr")
install.packages("readr")


library(rpart)
library(rpart.plot)
library(caret)
library(dplyr)
library(readr)

data <- read.csv("C:\\Users\\saulb\\Downloads\\dataarbol.csv",
                 fileEncoding = "latin1")


# ==========================================
# Convertir la variable a predecir en factor
# ==========================================
# Nuestro objetivo: predecir el SEXO de la víctima
data$SEXO <- as.factor(data$VIC_SEXO)

# ==========================================
# Eliminar filas sin sexo (vacías)
# ==========================================
data <- data %>% filter(SEXO != "")


modelo_data <- data %>% select(
  SEXO,            # Variable a predecir
  VIC_EDAD,
  TOTAL_HIJOS,
  VIC_ESCOLARIDAD,
  VIC_EST_CIV,
  HEC_DEPTO,
  AGR_SEXO
)

# ==========================================
# Dividir datos en entrenamiento y prueba
# ==========================================
set.seed(123)
train_index <- createDataPartition(modelo_data$SEXO, p = 0.7, list = FALSE)

train <- modelo_data[train_index, ]
test  <- modelo_data[-train_index, ]

# ==========================================
# Entrenar el árbol de decisión
# ==========================================
arbol <- rpart(SEXO ~ ., data = train, method = "class")

# Mostrar el árbol
rpart.plot(arbol, type = 2, extra = 0, under = TRUE,
           fallen.leaves = TRUE, box.palette = "BuGn",
           main = "Árbol de Decisión para predecir el Sexo de la Víctima")

# ==========================================
# Realizar predicción
# ==========================================
pred <- predict(arbol, test, type = "class")

# ==========================================
# Matriz de confusión
# ==========================================
confusionMatrix(pred, test$SEXO)
