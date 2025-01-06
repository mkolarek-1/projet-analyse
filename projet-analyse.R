


rm(list = ls())
#installer les packages nécessaires

install.packages("rvest")
install.packages("dplyr")
install.packages("shiny")

library(rvest)
library(dplyr)
library(shiny)

#scrapper les données


url <- "https://www.imdb.com/search/title/?genres=action&start=1&explore=title_type,genres"
page <- read_html(url)

titles <- page %>% html_nodes(".lister-item-header a") %>% html_text()
years <- page %>% html_nodes(".lister-item-year") %>% html_text()
genres <- Genre = c("Action" , "Aventure" , "Animation" , "Biographie" , "Comédie" , "Policier" , "Documentaire" ,"Drame", "Famille" , "Fantastique" , "Film Noir" , "Jeu Télévisé" , 
"Historique" , "Horreur" , "Musical" , "Comédie Musicale" , "Mystère" , "Actualités" , "Télé-Réalité" , "Romantique" , "Science-Fiction" , "Court-Métrage" , "Sport" , "Talk-Show" , "Thriller" , "Guerre" , "Western")
ratings <- page %>% html_nodes(".ratings-imdb-rating strong") %>% html_text()

movies <- data.frame(Title = titles, Year = years, Genre = genres, Rating = ratings)

#créer une interface utilisateur shiny texst 1

library(shiny)

ui <- fluidPage(
  titlePanel("Recherche de films"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Année:", min = 1900, max = 2025, value = c(2000, 2025)),
      selectInput("genre", "Genre:", choices = unique(movies$Genre)),
      sliderInput("rating", "Note:", min = 1, max = 10, value = c(1, 10))
    ),
    mainPanel(
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$results <- renderTable({
    movies %>%
      filter(Year >= input$year[1] & Year <= input$year[2],
             Genre == input$genre,
             Rating >= input$rating[1] & Rating <= input$rating[2])
  })
}

shinyApp(ui = ui, server = server)




#créer une interface utilisateur shiny texst 2
library(shiny)
library(dplyr)

# Exemple de données de films
movies <- data.frame(
  Title = c("Film A", "Film B", "Film C"),
  Year = c(2020, 2021, 2022),
  Genre = c("Action", "Drama", "Comedy"),
  Rating = c(8.5, 7.2, 9.0)
)

ui <- fluidPage(
  titlePanel("Recherche de films"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Année:", min = 1900, max = 2025, value = c(2000, 2025)),
      selectInput("genre", "Genre:", choices = unique(movies$Genre)),
      sliderInput("rating", "Note:", min = 1, max = 10, value = c(1, 10))
    ),
    mainPanel(
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$results <- renderTable({
    movies %>%
      filter(Year >= input$year[1] & Year <= input$year[2],
             Genre == input$genre,
             Rating >= input$rating[1] & Rating <= input$rating[2])
  })
}

shinyApp(ui = ui, server = server)


#créer une interface utilisateur shiny texst 3






# Installer les packages nécessaires
install.packages("rvest")
install.packages("dplyr")
install.packages("shiny")

# Charger les packages
library(rvest)
library(dplyr)
library(shiny)

# Scraper les données
url <- "https://www.imdb.com/search/title/?genres=action&start=1&explore=title_type,genres"
page <- tryCatch(read_html(url), error = function(e) NULL)

if (!is.null(page)) {
  titles <- page %>% html_nodes(".lister-item-header a") %>% html_text()
  years <- page %>% html_nodes(".lister-item-year") %>% html_text() %>% gsub("[^0-9]", "", .)
  ratings <- page %>% html_nodes(".ratings-imdb-rating strong") %>% html_text() %>% as.numeric()
  
  # Définir les genres
  genres <- c("Action", "Aventure", "Animation", "Biographie", "Comédie", "Policier", "Documentaire", "Drame", "Famille", "Fantastique", "Film Noir", "Jeu Télévisé", 
              "Historique", "Horreur", "Musical", "Comédie Musicale", "Mystère", "Actualités", "Télé-Réalité", "Romantique", "Science-Fiction", "Court-Métrage", "Sport", 
              "Talk-Show", "Thriller", "Guerre", "Western")
  
  # Créer le dataframe
  movies <- data.frame(Title = titles, Year = as.numeric(years), Genre = sample(genres, length(titles), replace = TRUE), Rating = ratings)
} else {
  movies <- data.frame(Title = character(), Year = numeric(), Genre = character(), Rating = numeric())
}

# Créer une interface utilisateur Shiny
ui <- fluidPage(
  titlePanel("Recherche de films"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Année:", min = 1900, max = 2025, value = c(2000, 2025)),
      selectInput("genre", "Genre:", choices = genres),
      sliderInput("rating", "Note:", min = 1, max = 10, value = c(1, 10))
    ),
    mainPanel(
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$results <- renderTable({
    movies %>%
      filter(Year >= input$year[1] & Year <= input$year[2],
             Genre == input$genre,
             Rating >= input$rating[1] & Rating <= input$rating[2])
  })
}

shinyApp(ui = ui, server = server)






#créer une interface utilisateur shiny texst 4


# Installer les packages nécessaires
install.packages("rvest")
install.packages("dplyr")
install.packages("shiny")

# Charger les packages
library(rvest)
library(dplyr)
library(shiny)

# Scraper les données
url <- "https://www.imdb.com/search/title/?genres=action&start=1&explore=title_type,genres"
page <- tryCatch(read_html(url), error = function(e) NULL)

if (!is.null(page)) {
  titles <- page %>% html_nodes(".lister-item-header a") %>% html_text()
  years <- page %>% html_nodes(".lister-item-year") %>% html_text() %>% gsub("[^0-9]", "", .)
  ratings <- page %>% html_nodes(".ratings-imdb-rating strong") %>% html_text() %>% as.numeric()
  
  # Définir les genres
  genres <- c("Action", "Aventure", "Animation", "Biographie", "Comédie", "Policier", "Documentaire", "Drame", "Famille", "Fantastique", "Film Noir", "Jeu Télévisé", 
              "Historique", "Horreur", "Musical", "Comédie Musicale", "Mystère", "Actualités", "Télé-Réalité", "Romantique", "Science-Fiction", "Court-Métrage", "Sport", 
              "Talk-Show", "Thriller", "Guerre", "Western")
  
  # Créer le dataframe
  movies <- data.frame(Title = titles, Year = as.numeric(years), Genre = sample(genres, length(titles), replace = TRUE), Rating = ratings)
} else {
  movies <- data.frame(Title = character(), Year = numeric(), Genre = character(), Rating = numeric())
}

# Créer une interface utilisateur Shiny
ui <- fluidPage(
  titlePanel("Recherche de films"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Année:", min = 1900, max = 2025, value = c(2000, 2025)),
      selectInput("genre", "Genre:", choices = genres),
      sliderInput("rating", "Note:", min = 1, max = 10, value = c(1, 10))
    ),
    mainPanel(
      uiOutput("results")  # Changement ici pour afficher une liste
    )
  )
)

server <- function(input, output) {
  filtered_movies <- reactive({
    movies %>%
      filter(Year >= input$year[1] & Year <= input$year[2],
             Genre == input$genre,
             Rating >= input$rating[1] & Rating <= input$rating[2])
  })
  
  output$results <- renderUI({
    movie_list <- filtered_movies()
    
    if (nrow(movie_list) == 0) {
      return("Aucun film trouvé.")
    }
    
    # Créer une liste de films
    tags$ul(
      lapply(1:nrow(movie_list), function(i) {
        tags$li(paste(movie_list$Title[i], "(", movie_list$Year[i], ") - Note:", movie_list$Rating[i]))
      })
    )
  })
}

shinyApp(ui = ui, server = server)

