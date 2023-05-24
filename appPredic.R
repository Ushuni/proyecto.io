library(shiny)
library(DBI)
library(RMySQL)
library(ggplot2)
library(dplyr)


con <- dbConnect(RMySQL::MySQL(), dbname = "DBRedDeportivaELO",
                 host = "localhost", port = 3306,
                 user = "root", password = "ushuni")

calcular_expectativas <- function(puntuaciones_elo1, puntuaciones_elo2) {
  expectativa <- 1 / (1 + 10^((puntuaciones_elo2 - puntuaciones_elo1) / 400))
  return(expectativa)
}

predecir_ganador <- function(puntuaciones_elo_a, puntuaciones_elo_b) {
  expectativa <- calcular_expectativas(puntuaciones_elo_a, puntuaciones_elo_b)
  if (expectativa > 0.5) {
    return("Ganó A")
  } else if (expectativa < 0.5) {
    return("Ganó B")
  } else {
    return("Empate")
  }
}

ui <- fluidPage(
  tags$head(
    tags$style(HTML(
      "
      .container {
        max-width: 600px;
        margin-top: 50px;
      }
      
      .title {
        text-align: center;
        margin-bottom: 30px;
      }
      
      .select-wrapper select {
        width: 100%;
        padding: 6px 12px;
        font-size: 14px;
        line-height: 1.42857143;
        color: #555555;
        background-color: #ffffff;
        background-image: none;
        border: 1px solid #cccccc;
        border-radius: 4px;
        box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
        transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
      }
      
      .predict-button {
        margin-top: 20px;
      }
      
      .result {
        font-weight: bold;
        margin-top: 20px;
      }
      
      .plot-wrapper {
        margin-top: 50px;
      }
      "
    ))
  ),
  
  titlePanel("Predicción de ganador con modelo Elo"),
  
  sidebarLayout(
    sidebarPanel(
      tags$div(class = "container",
               selectInput("equipo_a", "Equipo A:", choices = NULL),
               selectInput("equipo_b", "Equipo B:", choices = NULL),
               actionButton("predict_button", "Predecir ganador", class = "predict-button"),
               h4("Resultado:", class = "result"),
               div(plotOutput("expectativas_plot", height = "300px"), class = "plot-wrapper")
      )
    ),
    
    mainPanel(
      
    )
  )
)

server <- function(input, output, session) {
  observe({
    updateSelectInput(session, "equipo_a",
                      choices = dbGetQuery(con, "SELECT nombre FROM Tequipos"))
    updateSelectInput(session, "equipo_b",
                      choices = dbGetQuery(con, "SELECT nombre FROM Tequipos"))
  })
  
  observeEvent(input$predict_button, {
    equipo_a <- input$equipo_a
    equipo_b <- input$equipo_b
    
    puntuacion_elo_a_val <- dbGetQuery(con, paste0("SELECT puntuacion_elo FROM Tclasificadores_elo WHERE equipo_id = (SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_a, "')"))
    puntuacion_elo_b_val <- dbGetQuery(con, paste0("SELECT puntuacion_elo FROM Tclasificadores_elo WHERE equipo_id = (SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_b, "')"))
    
    puntuacion_elo_a <- puntuacion_elo_a_val$puntuacion_elo
    puntuacion_elo_b <- puntuacion_elo_b_val$puntuacion_elo
    
    resultado <- predecir_ganador(puntuacion_elo_a, puntuacion_elo_b)
    
    output$resultado <- renderText({
      resultado
    })
    
    data <- data.frame(Equipo = c(equipo_a, equipo_b),
                       Expectativa = c(calcular_expectativas(puntuacion_elo_a, puntuacion_elo_b),
                                       calcular_expectativas(puntuacion_elo_b, puntuacion_elo_a)))
    
    output$expectativas_plot <- renderPlot({
      ggplot(data, aes(x = "", y = Expectativa, fill = Equipo)) +
        geom_bar(stat = "identity", width = 1, color = "white") +
        coord_polar("y", start = 0) +
        labs(title = "Expectativas de victoria",
             x = NULL,
             y = NULL,
             fill = NULL) +
        theme_void() +
        theme(plot.title = element_text(hjust = 0.5))
    })
  })
}

shinyApp(ui, server)