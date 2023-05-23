# Instalar el paquete RMySQL si no lo tienes instalado
install.packages("RMySQL")

# Cargar el paquete RMySQL
library(RMySQL)

# Establecer la conexión a la base de datos
con <- dbConnect(MySQL(), user = "root", password = "ushuni", dbname = "DBRedDeportivaELO", host = "localhost")

# Ejecutar una consulta SQL
resultado <- dbGetQuery(con, "SELECT * FROM Tequipos")

# Mostrar los resultados
print(resultado)

# Cerrar la conexión
dbDisconnect(con)
