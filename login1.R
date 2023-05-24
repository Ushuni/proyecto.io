library(RMySQL)
library(shiny)

# Definir la interfaz de usuario
ui <- fluidPage(
  textInput("username", "Nombre de usuario"),
  passwordInput("password", "Contraseña"),
  actionButton("loginButton", "Iniciar sesión"),
  actionButton("createUserButton", "Crear usuario"),
  uiOutput("loggedInUI")
)

# Definir el servidor
server <- function(input, output, session) {
  # Variable reactiva para verificar si se ha iniciado sesión
  loggedIn <- reactiveVal(FALSE)
  
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
      # Establecer el valor de loggedIn a TRUE
      loggedIn(TRUE)
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
  
  # Renderizar la página de inicio de sesión exitoso
  output$loggedInUI <- renderUI({
    if (loggedIn()) {
      # Puedes cambiar esto para mostrar una página diferente después del inicio de sesión exitoso
      fluidPage(
        h1("Inicio de sesión exitoso"),
        actionButton("logoutButton", "Cerrar sesión")
      )
    }
  })
  
  # Función para cerrar sesión
  observeEvent(input$logoutButton, {
    loggedIn(FALSE)
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui, server)
