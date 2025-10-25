# ANÁLISIS: RELACIÓN ENTRE POSESIÓN OFENSIVA Y EFECTIVIDAD EN LIGA MX
# Objetivo: Investigar si los equipos que más dominan el área rival generan mejores oportunidades de gol

# ----------------------------
# 1. CARGA DE LIBRERÍAS
# ----------------------------
library(tidyverse)    # Manipulación y visualización de datos
library(rvest)        # Web scraping para obtener datos de FBRef
library(ggrepel)      # Etiquetas inteligentes en gráficos

# ----------------------------
# 2. EXTRACCIÓN DE DATOS EN TIEMPO REAL
# ----------------------------
# Fuente: FBRef.com - Estadísticas oficiales de Liga MX
url <- "https://fbref.com/en/comps/31/Liga-MX-Stats#all_stats_squads_passing"

# Extraemos la tabla de estadísticas de pases directamente de la página web
datos_pagina <- read_html(url)
tablas_pagina <- html_table(datos_pagina)

# La tabla número 10 contiene las estadísticas de pases que necesitamos
estadisticas_pases <- tablas_pagina[[10]]

# ----------------------------
# 3. PREPARACIÓN DEL ANÁLISIS
# ----------------------------
# Cargamos datos adicionales de tiros (previamente descargados)
datos_tiros <- read.csv("tiros.csv")

# Combinamos ambos datasets para tener métricas completas por equipo
datos_completos <- merge(estadisticas_pases, datos_tiros, by = "Equipo")

# ----------------------------
# 4. ANÁLISIS VISUAL: CORRELACIÓN ENTRE VARIABLES
# ----------------------------
ggplot(datos_completos, aes(x = Toques_area_rival, y = npxG)) +
  geom_point(color = "blue", size = 3, alpha = 0.7) +  # Puntos representando equipos
  
  # Etiquetas inteligentes que evitan solapamiento
  geom_text_repel(aes(label = Equipo), 
                  color = "black", 
                  size = 3.5,
                  box.padding = 0.3,
                  max.overlaps = 20) +
  
  # Personalización completa del tema y etiquetas
  labs(
    x = "Toques en Área Rival (Intensidad Ofensiva)", 
    y = "Goles Esperados sin Penales (Calidad de Oportunidades)",
    title = "Análisis Liga MX: ¿Más posesión en área rival = Mejores oportunidades?",
    subtitle = "Relación entre dominio ofensivo y efectividad en la generación de peligro",
    caption = "Fuente: FBRef.com | Análisis: [Tu Nombre]"
  ) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", color = "darkblue"),
    plot.subtitle = element_text(size = 12, color = "gray40"),
    axis.title = element_text(face = "bold", size = 12),
    panel.grid.major = element_line(color = "gray90"),
    plot.background = element_rect(fill = "white", color = NA)
  )

# ----------------------------
# 5. EXPORTACIÓN DE RESULTADOS
# ----------------------------
# Guardamos el dataset combinado para análisis futuros
write.csv(datos_completos, "pases_y_tiros.csv", row.names = FALSE)

# Cálculo de correlación para cuantificar la relación
correlacion <- cor(datos_completos$Toques_area_rival, datos_completos$npxG, use = "complete.obs")
print(paste("Correlación entre toques en área y xG:", round(correlacion, 3)))
