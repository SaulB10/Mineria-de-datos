library(readxl)
library(ggplot2)

data <- read_excel("C:\\Users\\saulb\\Downloads\\base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx")

data_kmeans <- data[, c("VIC_EDAD", "AGR_EDAD", "HEC_MES")]

data_kmeans[is.na(data_kmeans)] <- -1

data_scaled <- scale(data_kmeans)

k <- 3
cluster_result <- kmeans(data_scaled, centers = k, nstart = 25)

data_kmeans$cluster <- as.factor(cluster_result$cluster)

cluster_centers_original <- as.data.frame(
  scale(cluster_result$centers,
        center = attr(data_scaled, "scaled:center"),
        scale = attr(data_scaled, "scaled:scale"))
)
cluster_centers_original$cluster <- as.factor(1:k)

ggplot(data_kmeans, aes(x = VIC_EDAD, y = AGR_EDAD, color = cluster)) +
  geom_point(alpha = 0.6) +
  geom_point(data = cluster_centers_original,
             aes(x = VIC_EDAD, y = AGR_EDAD),
             color = "black", size = 4, shape = 17) +
  labs(
    title = paste("Agrupamiento K-Means (k=", k, "): Edad de la Víctima vs. Edad del Agresor"),
    x = "Edad de la Víctima (VIC_EDAD)",
    y = "Edad del Agresor (AGR_EDAD)",
    color = "Clúster"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

aggregate(data_kmeans[, c("VIC_EDAD", "AGR_EDAD", "HEC_MES")], by=list(Clúster=data_kmeans$cluster), FUN=mean)
