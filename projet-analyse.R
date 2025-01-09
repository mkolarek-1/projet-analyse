rm(list = ls())


# Installer les packages nécessaires
install.packages("rvest")
install.packages("dplyr")
install.packages("shiny")

# Charger les packages
library(rvest)
library(dplyr)
library(shiny)
library(ggplot2)
library(stringr)
library(XML)
#code avec TMDB
#lien du site a scrapper
link = "https://www.themoviedb.org/movie?language=fr"
page = read_html(link)
#utilisation d'une extension chrome  pour pouvoir sélectionner l'élément a scrapper sur la page puis transformation en texte

#récupération du nom du film
name = page %>% html_nodes("#page_1 .content a") %>% html_text()%>% str_trim()
movies_link = page %>% html_nodes("#page_1 .content a") %>% html_attr("href")  %>%
 paste("https://www.themoviedb.org",.,sep="") 

#récupération de la note film, petit problème ici l'exentsion chrome n'arrivait a détécter que la balise "canva" mais qui ne permettait pas de récupérer
#la note du dit film, il a fallut fouiller un peu dans le code html pour trouver ou se trouvait la note du film

notes =page %>% html_nodes(".user_score_chart") %>%  html_attr("data-percent")
#récupération de la date du film

date = page %>% html_nodes("#page_1 .content p") %>% html_text()%>% str_trim()
#récupération du genre du film

gender = sapply (movies_link, FUN = get_gender, USE.NAMES = FALSE)
#le genre du film n'apparait pas de base sur le site il faut cliquer d'abord sur le film chosit pour pouvoir le voir d'ou la création de movies_link et de get_gender
#qui permettent de cliquer sur le film et puis de séléctionner le genre du film ; la dernière partie de movie_gender permet de créer une colonne avec le genre
get_gender = function(movies_link) {
  movie_page = read_html(movies_link)
  movie_gender = movie_page %>% html_nodes(".genres a ") %>%  
    html_text() %>% paste (collapse = ",")
  return(movie_gender)
}
#création d'un data frame contenant le nom, la note, la date et le ou les genres du film

movies = data.frame( name , notes , date , gender )
# Interface Shiny
ui <- fluidPage(
  titlePanel("Moteur de recherche de films"),
  
  sidebarLayout(
    sidebarPanel(
      # Entrée pour rechercher par genre
      textInput("genre", "Rechercher par genre:", value = ""),
      
      # Sélectionner la note
      sliderInput("note", "Sélectionner une note:",
                  min = 0, max = 100, value = c(0, 100)),
      
      # Sélectionner l'année
      sliderInput("year", "Sélectionner une année:",
                  min = 1900, max = 2025, value = c(1900, 2025), step = 1)
    ),
    
    mainPanel(
      # Afficher les films correspondant aux critères de recherche
      tableOutput("film_table")
    )
  )
)

# Serveur Shiny
server <- function(input, output) {
  
  # Filtrer les films selon les critères
  filtered_movies <- reactive({
    
    # Filtrer par genre seulement si le genre est spécifié
    if (input$genre != "") {
      filtered_genre <- movies %>%
        filter(grepl(input$genre, gender, ignore.case = TRUE))
    } else {
      filtered_genre <- movies  # Si le genre n'est pas spécifié, prendre tous les films
    }
    
    # Si un genre a été sélectionné, ne pas appliquer les filtres de note et d'année
    if (input$genre != "") {
      return(filtered_genre)  # Si un genre est donné, on ne filtre que par genre
    }
    
    # Sinon, on applique aussi les filtres pour la note et l'année
    filtered_note <- filtered_genre %>%
      filter(as.numeric(notes) >= input$note[1] & as.numeric(notes) <= input$note[2])
    
    # Filtrer par année
    filtered_year <- filtered_note %>%
      filter(as.numeric(substring(date, 1, 4)) >= input$year[1] & as.numeric(substring(date, 1, 4)) <= input$year[2])
    
    return(filtered_year)
  })
  
  # Afficher la table des films filtrés
  output$film_table <- renderTable({
    filtered_movies()
  })
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)

  
  
