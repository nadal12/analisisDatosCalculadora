library(readr)

#Leer datos i mostrar su estructura. 
data <- read_delim("dades.csv", ";", escape_double = FALSE, trim_ws = TRUE)
str(data)

#Quitar valores NA
data <- na.omit(data)

#Convertir las columnas "grup" y "esquerra/dreta" a factor.
data$`Grup (BM o MB)` <- factor(data$`Grup (BM o MB)`)
data$`Esquerra/Dreta` <- factor(data$`Esquerra/Dreta`)

summary(data)

#Seleccionar columnas necesarias para este análisis. 
selectedData <- data[, c(-2:-4)]
str(selectedData)

#Convertir a long format. 
library(tidyr)