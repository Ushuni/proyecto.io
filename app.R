library(shiny)
library(DBI)
library(RMySQL)
library(ggplot2)
library(plotly)
library(magrittr)
library(shiny)
library(shinyjs)


# Cerrar todas las conexiones a la base de datos
conns <- dbListConnections(drv = RMySQL::MySQL())
for (conn in conns) {
  dbDisconnect(conn)
}
# Establecer la conexión a la base de datos
con <- dbConnect(RMySQL::MySQL(), dbname = "DBRedDeportivaELO",
                 host = "localhost", port = 3306,
                 user = "root", password = "ushuni")

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

# Definir la interfaz de la aplicación
ui <- fluidPage(
  useShinyjs(),  # Cargar shinyjs
  tags$head(
    tags$style(
      HTML(
        "
        .sidebar-panel {
          background-color: #f8f9fa;
          padding: 15px;
          border-radius: 5px;
          box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
        }

        .btn-calcular {
          background-color: #007bff;
          color: #fff;
          font-weight: bold;
          padding: 8px 16px;
          border-radius: 4px;
          border: none;
        }
        
        .btn-cerrar {
          background-color: #dc3545;
          color: #fff;
          font-weight: bold;
          padding: 8px 16px;
          border-radius: 4px;
          border: none;
        }
        
        .btn-redireccionar {
  background-color: #28a745;
  color: #fff;
  font-weight: bold;
  padding: 8px 16px;
  border-radius: 4px;
  border: none;
  margin-top: 10px;
}

        .tabla-resultados {
          margin-top: 20px;
        }

        .grafica-resultados {
          margin-top: 20px;
          text-align: center;
        }
        "
      )
    )
  ),
  sidebarLayout(
    sidebarPanel(
      tags$div(
        class = "sidebar-panel",
        selectInput("equipo_a", "Equipo Local:", choices = NULL),
        selectInput("equipo_b", "Equipo Visitante:", choices = NULL),
        selectInput("resultado", "Resultado:",
                    choices = c("Ganó Equipo Local", "Empate", "Ganó Equipo Visitante")),
        actionButton("calcular", "Calcular", class = "btn-calcular"),
        actionButton("cerrar", "Cerrar", class = "btn-cerrar"),
        actionButton("redireccionar", "Redireccionar", class = "btn-redireccionar")
        
        
      )
    ),
    mainPanel(
      tableOutput("tabla_resultados"),
      plotOutput("grafica_barras"),  # Gráfica de barras
      plotlyOutput("grafica_resultados")  # Cambio: Utilizar plotlyOutput en lugar de plotOutput, grafica circular
    )
  )
)

# Definir la lógica de la aplicación
server <- function(input, output, session) {
  puntuacion_elo_a <- reactiveVal(0)
  puntuacion_elo_b <- reactiveVal(0)
  
  # Obtener todas las puntuaciones Elo
  puntuaciones_elo_todos <- dbGetQuery(con, "SELECT nombre, puntuacion_elo FROM Tequipos JOIN Tclasificadores_elo ON Tequipos.id_equipo = Tclasificadores_elo.equipo_id")
  
  # Eliminar los equipos seleccionados de la lista
  puntuaciones_elo_todos <- puntuaciones_elo_todos[!(puntuaciones_elo_todos$nombre %in% c(equipo_a, equipo_b)), ]
  
  
  observe({
    updateSelectInput(session, "equipo_a",
                      choices = dbGetQuery(con, "SELECT nombre FROM Tequipos"))
    updateSelectInput(session, "equipo_b",
                      choices = dbGetQuery(con, "SELECT nombre FROM Tequipos"))
  })
  
  observeEvent(input$calcular, {
    equipo_a <- input$equipo_a
    equipo_b <- input$equipo_b
    resultado <- switch(input$resultado,
                        "Ganó Equipo Local" = 1,
                        "Empate" = 0.5,
                        "Ganó Equipo Visitante" = 0)
    
    puntuacion_elo_a_val <- dbGetQuery(con, paste0("SELECT puntuacion_elo FROM Tclasificadores_elo WHERE equipo_id = (SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_a, "')"))
    puntuacion_elo_b_val <- dbGetQuery(con, paste0("SELECT puntuacion_elo FROM Tclasificadores_elo WHERE equipo_id = (SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_b, "')"))
    
    puntuacion_elo_a(puntuacion_elo_a_val$puntuacion_elo)
    puntuacion_elo_b(puntuacion_elo_b_val$puntuacion_elo)
    
    # Calcular expectativas y nuevas puntuaciones Elo
    expectativa_a <- calcular_expectativas(puntuacion_elo_a(), puntuacion_elo_b())
    expectativa_b <- calcular_expectativas(puntuacion_elo_b(), puntuacion_elo_a())
    nueva_puntuacion_elo_a <- actualizar_puntuaciones_elo(puntuacion_elo_a(), expectativa_a, resultado, 20)
    nueva_puntuacion_elo_b <- actualizar_puntuaciones_elo(puntuacion_elo_b(), expectativa_b, 1 - resultado, 20)
    
    # Obtener el id del equipo local
    equipo_local_id <- dbGetQuery(con, paste0("SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_a, "'"))
    
    # Obtener el id del equipo visitante
    equipo_visitante_id <- dbGetQuery(con, paste0("SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_b, "'"))
    
    # Actualizar las puntuaciones Elo en la base de datos
   
   
    
    dbExecute(con, paste0("UPDATE Tclasificadores_elo SET puntuacion_elo = ", nueva_puntuacion_elo_a,
                          " WHERE equipo_id = ", equipo_local_id$id_equipo))
    dbExecute(con, paste0("UPDATE Tclasificadores_elo SET puntuacion_elo = ", nueva_puntuacion_elo_b,
                          " WHERE equipo_id = ", equipo_visitante_id$id_equipo))
    
    # Guardar el resultado en la tabla de partidos
    dbExecute(con, paste0("INSERT INTO Tpartidos (equipo_local_id, equipo_visitante_id, resultado) VALUES (",
                          equipo_local_id$id_equipo, ", ", equipo_visitante_id$id_equipo, ", ", resultado, ")"))
    
    
  })
  # Lógica para cerrar la aplicación
  observeEvent(input$cerrar, {
    stopApp()
  })
  observeEvent(input$redireccionar, {
    runjs("window.location.href = 'C:\\Users\\Windows 10\\Desktop\\PROYECTO\\proyecto.io\\appPredic.R'")
  
  
    
  })
  # Mostrar la tabla de los resultados
  output$tabla_resultados <- renderTable({
    data.frame(
      Equipo = c(input$equipo_a, input$equipo_b),
      Puntuacion_Elo = c(puntuacion_elo_a(), puntuacion_elo_b())
    )
  })
  
  # Mostrar la gráfica de los resultados en barras
  output$grafica_barras <- renderPlot({
    df <- subset(puntuaciones_elo_todos, !nombre %in% c(input$equipo_a, input$equipo_b))
    df <- rbind(df, data.frame(nombre = c(input$equipo_a, input$equipo_b),
                               puntuacion_elo = c(puntuacion_elo_a(), puntuacion_elo_b())))
    
    #porcentajes <- round(df$puntuacion_elo * 100, 1)
    porcentajes <- scales::percent(df$Puntuacion_Elo, accuracy = 0.1)
    
    p <- ggplot(df, aes(x = nombre, y = puntuacion_elo)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      geom_text(aes(label = puntuacion_elo), vjust = -0.5, size = 3) +
      labs(title = "Puntuaciones Elo actualizadas",
           x = "Equipo", y = "Puntuación Elo") +
      theme_minimal()
    
    
    
    
    
    
    p <- p + theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5, margin = margin(b = 20)),
      axis.text = element_text(angle=45, hjust=1,size = 12),
      axis.title = element_text(size = 14),
      axis.title.y = element_text(margin = margin(r = 10)),
      panel.grid.major.y = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      plot.margin = margin(10, 80, 10, 10)  # Ajusta los márgenes del gráfico
    )
    
    p
  })
  
  
  
  # Mostrar la gráfica estadística circular
  output$grafica_resultados <- renderPlotly({  # Cambio: Utilizar renderPlotly en lugar de renderPlot
    df <- data.frame(
      Equipo = c(input$equipo_a, input$equipo_b,puntuaciones_elo_todos$nombre),
      Puntuacion_Elo = c(puntuacion_elo_a(), puntuacion_elo_b(),puntuaciones_elo_todos$puntuacion_elo)
    )
    
    p <- plot_ly(df, labels = df$Equipo, values = df$Puntuacion_Elo, type = "pie")
    p <- p %>% layout(title = "Puntuaciones Elo actualizadas")  # Cambio: Utilizar layout en lugar de add_layout
    p
  
  
  
})
  

  
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}

# Ejecutar la aplicación
shinyApp(ui, server)
