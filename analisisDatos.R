library(readr)
#Leer datos i mostrar su estructura. 
data <- read_delim("dades.csv", ";", escape_double = FALSE, trim_ws = TRUE)
str(data)

#Quitar filas que contengan valores NA
data <- na.omit(data)

#Convertir las columnas "grup" y "esquerra/dreta" a factor.
data$`Grup (BM o MB)` <- factor(data$`Grup (BM o MB)`)
data$`Esquerra/Dreta` <- factor(data$`Esquerra/Dreta`)

#Visualizar resumen de los datos. 
summary(data)

#Seleccionar columnas necesarias para este análisis. 
selectedData <- data[, c(-2:-4)]
str(selectedData)

# Análisis inicial - Visualización de los datos

#Cálculo de la media de tiempo para los dos modelos. 
meanBase <- mean(selectedData$`Temps model base (s)`)
meanImproved <- mean(selectedData$`Temps model millorat (s)`)

#Introducir los datos dentro de una tabla para después representarlos mediante
#un gráfico de estilo barplot.
meanTable <- c(meanBase, meanImproved)
barplot(meanTable, ylim= c(0,150), 
        xlim=c(0,5.3), col=c('red', 'green'), 
        ylab ="Mitjana temps (s)",
        names.arg = c("Model base","Model millorat"))

# Análisis completo
library(tidyr)

#Convertir a long format.
selectedDataLong <- gather(selectedData, Layout, Temps, `Temps model base (s)`:`Temps model millorat (s)`)
head(selectedDataLong)
str(selectedDataLong)

#Convertir columna "Layout" y "codi participant" a factor
selectedDataLong$Layout <- factor(selectedDataLong$Layout)
selectedDataLong$`Codi participant` <- factor(selectedDataLong$`Codi participant`)
str(selectedDataLong)

#Comprobar si se cumple la asunción de normalidad.

#Primero se miran los tamaños. 
length(data$`Temps model base (s)`)
length(data$`Temps model millorat (s)`)

#Como la medida de los datos es inferior a 50, se utiliza el test de Shapiro-Wilk. 

#Comprobar modelo base. 
saphiro_base <- shapiro.test(data$`Temps model base (s)`)
saphiro_base
saphiro_base$p.value >= .05  #Si es true significa que se cumple para el modelo base.  

#Comprobar modelo mejorado 
saphiro_improved <- shapiro.test(data$`Temps model millorat (s)`)
saphiro_improved
saphiro_improved$p.value >= .05 #Si es true significa que se cumple para el modelo mejorado. 

# Como los dos modelos cumplen la asunción de normalidad se puede decir que
# nuestros datos siguen uns distribución normal y se puede utilizar un test 
# paramétrico. 

# El test paramétrico elegido es el: Repeated-measures ANOVA. 
aov = aov(Temps~Layout+Error(`Codi participant`/Layout), selectedDataLong)
summary(aov)