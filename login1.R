library(RMySQL)
library(shiny)
library(shinyjs)
dbDisconnect(con)
# Definir la interfaz de usuario
ui <- fluidPage(
  useShinyjs(),  # Importante: utilizar shinyjs
  
  # Página de inicio de sesión
  div(id = "loginPage",
      style = "display: flex; align-items: center; justify-content: center; height: 100vh;",
      div(style = "text-align: center;",
          tags$h1("Iniciar sesión"),
          textInput("username", "Nombre de usuario"),
          passwordInput("password", "Contraseña"),
          actionButton("loginButton", "Iniciar sesión"),
          actionButton("createUserButton", "Crear usuario"),
          htmlOutput("loginStatus")  # Mostrar mensaje de estado
      )
  ),
  
  # Página de sesión iniciada
  div(id = "loggedInPage", style = "display: none;",
      style = "display: flex; align-items: center; justify-content: center; height: 100vh;",
      div(style = "text-align: center;",
          conditionalPanel(
            condition = "input.createUserButton > 0 && input.saveUserButton == 0",  # Mostrar campos de creación de usuario antes de guardar
            tags$h2("Crear nuevo usuario"),
            textInput("newUsername", "Nuevo nombre de usuario"),
            textInput("newEmail", "Nuevo email"),
            selectInput("newTipo", "Tipo de nuevo usuario", choices = c("analista", "periodista")),  # Campo de selección para el tipo de usuario
            passwordInput("newPassword", "Nueva contraseña"),
            actionButton("saveUserButton", "Guardar usuario"),
            htmlOutput("userStatus")  # Mostrar mensaje de estado para el nuevo usuario
          ),
          conditionalPanel(
            condition = "input.createUserButton == 0 || input.saveUserButton > 0",  # Ocultar campos de creación de usuario después de guardar
            actionButton("logoutButton", "Cerrar sesión"),
            htmlOutput("creationStatus")  # Mostrar mensaje de estado de creación de usuario
          )
      )
  )
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
      updateLoginStatus("Usuario o contraseña incorrectos")
    }
  })
  
  # Función para crear un nuevo usuario
  observeEvent(input$createUserButton, {
    # Ocultar la página de inicio de sesión
    shinyjs::hide("loginPage")
    
    # Mostrar la página para crear un nuevo usuario
    shinyjs::show("loggedInPage")
  })
  
  # Función para guardar el nuevo usuario en la base de datos
  observeEvent(input$saveUserButton, {
    # Verificar que los campos estén completos
    if (is.null(input$newUsername) || is.null(input$newEmail) || is.null(input$newPassword)) {
      updateUserStatus("Por favor, complete todos los campos")
      return()
    }
    
    # Asignar el valor correcto al campo "id_rol" según el tipo seleccionado
    id_rol <- ifelse(input$newTipo == "analista", 1, 2)
    
    # Establecer la conexión a la base de datos
    con <- dbConnect(MySQL(), 
                     user = "root", 
                     password = "ushuni", 
                     dbname = "DBRedDeportivaELO",
                     host = "localhost")
    
    # Insertar el nuevo usuario en la base de datos
    query <- sprintf("INSERT INTO Tusuarios (nombre, email, tipo, id_rol, password) 
                      VALUES ('%s', '%s', '%s', %d, '%s')",
                     input$newUsername, input$newEmail, input$newTipo, id_rol, input$newPassword)
    dbExecute(con, query)
    
    # Cerrar la conexión
    dbDisconnect(con)
    
    updateUserStatus("Usuario creado exitosamente")
    
    # Esperar 3 segundos antes de ocultar el mensaje de estado de creación de usuario y mostrar la página de inicio de sesión
    invalidateLater(3000, session)
    updateUserStatus("")  # Borrar el mensaje de estado de creación de usuario
    
    # Ocultar la página de creación de usuario y mostrar la página de inicio de sesión
    shinyjs::hide("loggedInPage")
    shinyjs::show("loginPage")
  })
  
  # Función para actualizar el mensaje de estado para el nuevo usuario
  updateUserStatus <- function(message) {
    output$userStatus <- renderText(message)
  }
  
  # Función para actualizar el mensaje de estado de inicio de sesión
  updateLoginStatus <- function(message) {
    output$loginStatus <- renderText(message)
  }
  
  # Observar el estado de inicio de sesión y mostrar/ocultar páginas
  observe({
    if (loggedIn()) {
      shinyjs::hide("loginPage")
      shinyjs::show("loggedInPage")
    } else {
      shinyjs::show("loginPage")
      shinyjs::hide("loggedInPage")
    }
  })
  
  # Función para cerrar sesión
  observeEvent(input$logoutButton, {
    loggedIn(FALSE)
    updateLoginStatus("")  # Borrar el mensaje de estado
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui, server)
