library(shiny)
library(shinythemes)
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

predecir_ganador <- function(puntuaciones_elo_a, puntuaciones_elo_b, nombres_a, nombres_b) {
  expectativa_equipo_a <- calcular_expectativas(puntuaciones_elo_a, puntuaciones_elo_b)
  expectativa_equipo_b <- calcular_expectativas(puntuaciones_elo_b, puntuaciones_elo_a)

  diferencia_elo <- puntuaciones_elo_a - puntuaciones_elo_b

  explicacion <- ""
  if (diferencia_elo > 0) {
    explicacion <- paste("El equipo local tiene una ventaja en puntuación Elo de", round(diferencia_elo, 2))
  } else if (diferencia_elo < 0) {
    explicacion <- paste("El equipo visitante tiene una ventaja en puntuación Elo de", round(abs(diferencia_elo), 2))
  } else {
    explicacion <- "Ambos equipos tienen la misma puntuación Elo"
  }

  resultado <- ifelse(expectativa_equipo_a > expectativa_equipo_b, "Ganó Equipo Local",
                      ifelse(expectativa_equipo_a < expectativa_equipo_b, "Ganó Equipo Visitante", "Empate"))

  explicacion_resultado <- paste("La probabilidad de victoria para el equipo local es del",
                                 round(expectativa_equipo_a * 100, 2), "%, mientras que para el equipo visitante es del",
                                 round(expectativa_equipo_b * 100, 2), "%.")

  return(list(resultado = resultado, explicacion = explicacion, explicacion_resultado = explicacion_resultado,
              nombres_a = nombres_a, nombres_b = nombres_b))
}

ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  tags$head(
    tags$style(HTML(
      "
      .container {
        max-width: 400px;
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
      
      .player-list {
        margin-top: 20px;
      }
      "
    ))
  ),
  
  titlePanel("Predicción de ganador con modelo Elo"),
  
  sidebarLayout(
    sidebarPanel(
      tags$div(class = "container",
               selectInput("equipo_a", "Equipo Local:", choices = NULL),
               selectInput("equipo_b", "Equipo Visitante:", choices = NULL),
               actionButton("predict_button", "Predecir ganador", class = "predict-button"),
               p(id = "explicacion_text", class = "result")
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Gráfica de expectativas", plotOutput("expectativas_plot", height = "400px")),
        tabPanel("Probabilidad de Victoria", plotOutput("probabilidad_plot", height = "400px")),
        tabPanel("Jugadores más relevantes",
                 plotOutput("jugadores_relevantes_plot", height = "400px"),
                 p(id = "explicacion_jugadores_relevantes", class = "result"),
                 p(id = "equipo_a_players", class = "player-list"),
                 p(id = "equipo_b_players", class = "player-list")
        )
      )
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
    
    nombres_a_val <- dbGetQuery(con, paste0("SELECT nombre FROM Tjugadores WHERE equipo_id = (SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_a, "')"))
    nombres_b_val <- dbGetQuery(con, paste0("SELECT nombre FROM Tjugadores WHERE equipo_id = (SELECT id_equipo FROM Tequipos WHERE nombre = '", equipo_b, "')"))
    
    puntuacion_elo_a <- puntuacion_elo_a_val$puntuacion_elo
    puntuacion_elo_b <- puntuacion_elo_b_val$puntuacion_elo
    
    nombres_a <- nombres_a_val$nombre
    nombres_b <- nombres_b_val$nombre
    
    resultado <- predecir_ganador(puntuacion_elo_a, puntuacion_elo_b, nombres_a, nombres_b)
    
    output$explicacion_text <- renderText({
      resultado$explicacion_resultado
    })
    
    expectativa_a <- calcular_expectativas(puntuacion_elo_a, puntuacion_elo_b)
    expectativa_b <- calcular_expectativas(puntuacion_elo_b, puntuacion_elo_a)
    
    data <- data.frame(Equipo = c(equipo_a, equipo_b),
                       Expectativa = c(expectativa_a, expectativa_b),
                       Probabilidad = c(paste0(round(expectativa_a * 100, 1), "%"), paste0(round(expectativa_b * 100, 1), "%")),
                       Nombres = c(paste(nombres_a, collapse = ", "), paste(nombres_b, collapse = ", ")))
    
    output$expectativas_plot <- renderPlot({
      ggplot(data, aes(x = "", y = Expectativa, fill = Equipo)) +
        geom_bar(stat = "identity", width = 1) +
        coord_polar("y") +
        theme_void() +
        labs(title = "Expectativas de victoria", fill = "Equipo", x = NULL, y = NULL) +
        scale_fill_manual(values = c("#2ecc71", "#3498db"))
    })
    
    output$probabilidad_plot <- renderPlot({
      ggplot(data, aes(x = Equipo, y = Expectativa, fill = Equipo)) +
        geom_bar(stat = "identity") +
        theme_minimal() +
        labs(title = "Probabilidad de victoria", fill = "Equipo", x = NULL, y = "Probabilidad (%)") +
        scale_fill_manual(values = c("#2ecc71", "#3498db"))
    })
    
    output$equipo_a_players <- renderText({
      paste("Jugadores más relevantes de", equipo_a, ":")
      paste(resultado$nombres_a, collapse = ", ")
    })
    
    output$equipo_b_players <- renderText({
      paste("Jugadores más relevantes de", equipo_b, ":")
      paste(resultado$nombres_b, collapse = ", ")
    })
    output$explicacion_jugadores_relevantes <- renderText({
      paste("Jugadores más relevantes para la predicción:")
    })

    output$jugadores_relevantes_plot <- renderPlot({
      jugadores_relevantes <- c(resultado$nombres_a, resultado$nombres_b)
      relevancia <- c(rep("Equipo Local", length(resultado$nombres_a)), rep("Equipo Visitante", length(resultado$nombres_b)))
      data <- data.frame(Jugador = jugadores_relevantes, Relevancia = relevancia)
      
      # Filtrar los jugadores más relevantes basados en la puntuación Elo
      jugadores_relevantes_filtrados <- data %>%
        group_by(Jugador) %>%
        summarise(Relevancia = first(Relevancia)) %>%
        top_n(n = 3, wt = Relevancia) %>%
        arrange(desc(Relevancia)) %>%
        pull(Jugador)

      data_filtrada <- data %>% filter(Jugador %in% jugadores_relevantes_filtrados)

      ggplot(data_filtrada, aes(x = Jugador, fill = Relevancia)) +
        geom_bar(stat = "count", width = 0.5, show.legend = FALSE) +
        labs(x = "Jugador", y = "Cantidad", fill = "Relevancia") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        ggtitle("Jugadores más relevantes para la predicción")
    })
  })
}

shinyApp(ui, server)
