#~
#cargando datos
#library(EloSteepness)
#library(readr)
#library(readxl)
#library(tidyr)
#library(elo)
#library(EloChoice)
#library(EloOptimized)
#library(EloRating)
file.choose()
#la ruta de los datos
ruta_datos <- "C:\\Users\\Windows 10\\Desktop\\PROYECTO\\proyecto.io\\Datos\\2020-Apertura.xlsx"
#viendo los datos
excel_sheets(ruta_datos)
#importando datos del caso 2020
datos_2020 <- read_excel(ruta_datos, sheet = "Sheet1")
#asignando
datos<- data.frame(datos_2020)
datos
Equipo<- datos_2020$Equipo
partidoJugados<- datos$PG
partidosGanados<-datos$G
partidosEmpatados<-datos$E   
partidosPerdidos<-datos$P
puntosEquipo<-datos$Pts
PtsELO<-datos$PtsELO
head(Equipo)
hist(partidoJugados, col = "yellow")
hist(partidosGanados,col = "blue")
plot(partidosGanados, col="orange", type = "o")

plot(puntosEquipo~partidosGanados)
cor.test(puntosEquipo,partidosGanados)

typeof(PtsELO)
typeof(puntosEquipo)

modelo1<- lm(puntosEquipo~partidosGanados) 

summary(modelo1)

modelo1$coefficients
abline(modelo1,col="red")

#con el modelo ELo

# Función para calcular las expectativas de victoria basadas en las puntuaciones Elo
calcular_expectativas <- function(puntuaciones_elo1, puntuaciones_elo2) {
  expectativa <- 1 / (1 + 10^((puntuaciones_elo2 - puntuaciones_elo1) / 400))
  return(expectativa)
}

# Función para actualizar las puntuaciones Elo después de un partido
actualizar_puntuaciones_elo <- function(puntuaciones_elo, expectativa, resultado, factor_ajuste) {
  nueva_puntuacion_elo <- puntuaciones_elo + factor_ajuste * (resultado - expectativa)
  return(nueva_puntuacion_elo)
}

# Ejemplo de actualización de puntuaciones después de un partido
equipo_a <- "Royal Pari"
equipo_b <- "Blooming"
resultado_partido <- 1  # 1 para victoria del Equipo A, 0.5 para empate, 0 para victoria del Equipo B

# Obtener las puntuaciones Elo de los equipos desde la base de datos
puntuacion_elo_a <- datos$PtsELO[datos$Equipo == equipo_a]
puntuacion_elo_b <- datos$PtsELO[datos$Equipo == equipo_b]

# Calcular las expectativas de victoria
expectativa_a <- calcular_expectativas(puntuacion_elo_a, puntuacion_elo_b)
expectativa_b <- calcular_expectativas(puntuacion_elo_b, puntuacion_elo_a)

# Actualizar las puntuaciones Elo
factor_ajuste <- 32  # Factor de ajuste (puedes modificarlo según tus necesidades)
nueva_puntuacion_elo_a <- actualizar_puntuaciones_elo(puntuacion_elo_a, expectativa_a, resultado_partido, factor_ajuste)
nueva_puntuacion_elo_b <- actualizar_puntuaciones_elo(puntuacion_elo_b, expectativa_b, 1 - resultado_partido, factor_ajuste)

# Actualizar las puntuaciones Elo en la base de datos
datos$PtsELO[datos$Equipo == equipo_a] <- nueva_puntuacion_elo_a
datos$PtsELO[datos$Equipo == equipo_b] <- nueva_puntuacion_elo_b
datos


# Mostrar las puntuaciones Elo actualizadas
print(datos)

#guardando BD
library(writexl)
# Crear una copia del dataframe original
datos_actualizados <- datos

# Actualizar las puntuaciones Elo en el dataframe
datos_actualizados$PtsELO[datos_actualizados$Equipo == equipo_a] <- nueva_puntuacion_elo_a
datos_actualizados$PtsELO[datos_actualizados$Equipo == equipo_b] <- nueva_puntuacion_elo_b

# Guardar el dataframe actualizado en un nuevo archivo Excel
write_xlsx(datos_actualizados, "C:\\Users\\Windows 10\\Desktop\\PROYECTO\\proyecto.io\\Datos\\2020-Apertura.xlsx")


#para git
#git config user.email "nigomi.34@gmail.com"
#git config user.name "Ushuni"

