library(RMySQL)
library(shiny)
library(shinyjs)

# Definir la interfaz de usuario
ui <- fluidPage(
  useShinyjs(),  # Cargar la extensión shinyjs
  textInput("username", "Nombre de usuario"),
  passwordInput("password", "Contraseña"),
  actionButton("loginButton", "Iniciar sesión"),
  actionButton("createUserButton", "Crear usuario"),
  textOutput("status")
)

# Definir el servidor
server <- function(input, output, session) {
  # Función para el inicio de sesión
  observeEvent(input$loginButton, {
    # Establecer la conexión a la base de datos
    con <- dbConnect(MySQL(), 
                     user = "root", 
                     password = "ushuni", 
                     dbname = "DBRedDeportivaELO",
                     host = "localhost")
    
    # Consultar el usuario en la base de datos
    query <- sprintf("SELECT * FROM Tusuarios WHERE nombre='%s' AND password='%s'", 
                     input$username, input$password)
    result <- dbGetQuery(con, query)
    
    # Cerrar la conexión
    dbDisconnect(con)
    
    # Verificar si se encontró el usuario
    if (nrow(result) > 0) {
      # Redireccionar a otra página
      js$redirect("app.R")
    } else {
      output$status <- renderText("Usuario o contraseña incorrectos")
      # Aquí puedes manejar el caso de inicio de sesión fallido
    }
  })
  
  # Función para crear un nuevo usuario
  observeEvent(input$createUserButton, {
    # Establecer la conexión a la base de datos
    con <- dbConnect(MySQL(), 
                     user = "root", 
                     password = "ushuni", 
                     dbname = "DBRedDeportivaELO",
                     host = "localhost")
    
    # Insertar el nuevo usuario en la base de datos
    query <- sprintf("INSERT INTO Tusuarios (nombre, email, tipo, password) 
                      VALUES ('%s', '%s', '%s', '%s')",
                     input$username, input$email, input$tipo, input$password)
    dbExecute(con, query)
    
    # Cerrar la conexión
    dbDisconnect(con)
    
    output$status <- renderText("Usuario creado exitosamente")
    # Aquí puedes realizar acciones adicionales después de crear el usuario
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui, server)
