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

# Análisis inicial - Visualización de los datos
meanBase <- mean(selectedData$`Temps model base (s)`)
meanImproved <- mean(selectedData$`Temps model millorat (s)`)

meanTable <- c(meanBase, meanImproved)
barplot(meanTable, ylim= c(0,150), 
        xlim=c(0,5.3), col=c('red', 'green'), 
        ylab ="Mitjana temps (s)",
        names.arg = c("Model base","Model millorat"))


