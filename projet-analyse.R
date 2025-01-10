rm(list = ls())

# Charger les packages

library(rvest)
library(dplyr)
library(shiny)
library(DT)




#code avec allociné
#lien du site a scrapper
#le genre du film n'apparait pas de base sur le site il faut cliquer d'abord sur le film chosit pour pouvoir le voir d'ou la création de movies_link et de get_gender
#qui permettent de cliquer sur le film et puis de séléctionner le genre du film ; la dernière partie de movie_gender permet de créer une colonne avec le genre


get_director = function(movies_link) {
  movie_page = read_html(movies_link)
  movie_director = movie_page %>% html_nodes(".meta-body-info+ .meta-body-oneline .dark-grey-link") %>%  
    html_text() %>% paste (collapse = ",")
  return(movie_director) }

get_cast = function(movies_link) {
  movie_page = read_html(movies_link)
  movie_cast = movie_page %>% html_nodes(".meta-body-actor .dark-grey-link") %>%  
    html_text() %>% paste (collapse = ",")
  return(movie_cast) }


get_gender = function(movies_link) {
  movie_page = read_html(movies_link)
  movie_gender = movie_page %>% html_nodes(".meta-body-info .dark-grey-link") %>%  
    html_text() %>% paste (collapse = ",")
  return(movie_gender)
}
movies =data.frame()

for (page_result in seq(from=1, to = 5, by =1)){
  link =paste("https://www.allocine.fr/films/?page=",page_result,sep="")
  page = read_html(link)

#récupération du nom du film
name = page %>% html_nodes(".meta-affintiy-score .meta-title-link") %>% html_text()%>% str_trim()
movies_link = page %>% html_nodes(".meta-affintiy-score .meta-title-link") %>% html_attr("href")  %>%
  paste("https://www.allocine.fr",.,sep="") 

#récupération de la note film

notes = page %>% 
  html_node(".stareval-note") %>%  # Cibler la balise 
  html_text() %>%                  # Extraire le texte
  str_trim() %>%                   # Supprimer les espaces inutiles
  gsub(",", ".", .)            # Remplacer la virgule par un point (pour les décimales)
  

#récupération de la date du film

date = page %>% html_nodes(".date") %>% html_text()%>% str_trim()
#récupération du genre du film

gender = sapply (movies_link, FUN = get_gender, USE.NAMES = FALSE)

#casting du film
cast = sapply (movies_link, FUN = get_cast, USE.NAMES = FALSE)

#récupération du réalisateur/des réalisateurs 

director = sapply(movies_link, FUN = get_director, USE.NAMES = FALSE)
#création d'un data frame contenant le nom, la note, la date et le ou les genres du film

movies = rbind(movies,data.frame( name , notes , date , gender, cast , director))

print(paste("page:",page_result))
}



# Lancement de l'application Shiny
ui <- fluidPage(
  titlePanel("Recherche de Films"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("min_note", "Note minimale :", value = NA, min = 0, max = 10, step = 0.1),
      numericInput("max_note", "Note maximale :", value = NA, min = 0, max = 10, step = 0.1),
      textInput("date", "Date (année) :", ""),
      textInput("gender", "Genre :", ""),
      textInput("cast", "Casting :", ""),
      textInput("director", "Réalisateur :", "")
    ),
    
    mainPanel(
      DTOutput("filtered_movies")
    )
  )
)

server <- function(input, output, session) {
  # Convertir les notes en numérique si ce n'est pas déjà fait
  movies$notes <- as.numeric(movies$notes)
  
  # Filtrage dynamique des données
  filtered_movies <- reactive({
    df <- movies
    
    # Filtrage par note minimale
    if (!is.na(input$min_note)) {
      df <- df[df$notes >= input$min_note, ]
    }
    
    # Filtrage par note maximale
    if (!is.na(input$max_note)) {
      df <- df[df$notes <= input$max_note, ]
    }
    
    # Filtrage par date
    if (input$date != "") {
      df <- df[grepl(input$date, df$date, ignore.case = TRUE), ]
    }
    
    # Filtrage par genre
    if (input$gender != "") {
      df <- df[grepl(input$gender, df$gender, ignore.case = TRUE), ]
    }
    
    # Filtrage par casting
    if (input$cast != "") {
      df <- df[grepl(input$cast, df$cast, ignore.case = TRUE), ]
    }
    
    # Filtrage par réalisateur
    if (input$director != "") {
      df <- df[grepl(input$director, df$director, ignore.case = TRUE), ]
    }
    
    return(df)
  })
  
  # Afficher le tableau filtré
  output$filtered_movies <- renderDT({
    datatable(filtered_movies(), options = list(pageLength = 10))
  })
}

shinyApp(ui, server)





