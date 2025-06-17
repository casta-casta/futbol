library(tidyverse)
library(ggplot2)
library(rvest)
library(dplyr)
library(ggbeeswarm)
library(ggrepel)

url <- "https://fbref.com/en/comps/31/Liga-MX-Stats#all_stats_squads_passing"
datos <- read_html(url)
txt_pases <- html_text(url)

datos_final <- datos %>%
  html_table()
datos_final[[10]]
datos_final <- datos_final[[10]]
setwd('/Users/tre/Documents/proyectos personales/fútbol con r/datos')
write.csv(x= datos_final, file= "tiros.csv")

setwd("/Users/tre/Documents/proyectos personales/fútbol con r/datos")
datos_tiros <- read.csv("tiros.csv")
datos_pases <- read.csv("pases.csv")

pases_y_tiros <- merge(datos_pases, datos_tiros, by = "Equipo")

ggplot(pases_y_tiros, aes(x = Toques_area_rival, y = npxG)) +
  geom_point(color = "blue") + 
  geom_text_repel(aes(label = Equipo), 
                  color = "black", size = 5,  # Color y tamaño de las etiquetas
                  family = "Arial",  # Tipo de letra de las etiquetas
                  box.padding = 0.3) +# Dibujar los puntos  # Añadir las etiquetas
  labs(
    x = "Toques en área rival",  # Cambiar nombre del eje X
    y = "Goles esperados (sin contar penales)",    # Cambiar nombre del eje Y
    title = "Liga MX, Apertura 2024",
    caption= "Fuente: FBRef, 2024" #este es el pie de página
  ) +
  theme_minimal() +
  theme(
    # Cambiar el fondo del área de los datos (panel)
    panel.background = element_rect(fill = "lightpink", color = "black"),  # Fondo azul claro con borde negro
    
    # Cambiar el fondo del gráfico completo
    plot.background = element_rect(fill = "white", color = NA),  # Fondo marfil sin borde
    
    # Cambiar color y tipo de letra del título
    plot.title = element_text(size = 16, color = "blue", face = "bold", family = "Arial"),
    
    # Cambiar color y tipo de letra de los títulos de los ejes
    axis.title.x = element_text(size = 14, color = "blue", face = "bold", family = "Arial"),
    axis.title.y = element_text(size = 14, color = "blue", face = "bold", family = "Arial")
  )
write.csv(x= pases_y_tiros, file="pases y tiros.csv")
