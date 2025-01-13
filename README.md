### Documentation détaillée du code R pour le scraping et l'application Shiny

#### Chargement des bibliothèques

library(rvest)   # Utilisé pour extraire et manipuler des données à partir de pages HTML.
library(dplyr)   # Permet de manipuler et transformer les données de manière efficace.
library(shiny)   # Fournit un cadre pour créer des applications web interactives en R.
library(DT)      # Utilisé pour afficher des tableaux interactifs et dynamiques dans les applications Shiny.

#### Définition des fonctions pour scraper des données

get_director = function(movies_link) {
  # Charge la page HTML du film correspondant à l'URL fournie
  movie_page = read_html(movies_link)
  # Récupère le texte des éléments HTML contenant les informations du réalisateur
  movie_director = movie_page %>%
    html_nodes(".meta-body-info+ .meta-body-oneline .dark-grey-link") %>%
    html_text() %>%
    paste(collapse = ",")
  # Retourne les réalisateurs sous forme de chaîne de texte
  return(movie_director)
}

get_cast = function(movies_link) {
  # Charge la page HTML du film correspondant à l'URL fournie
  movie_page = read_html(movies_link)
  # Récupère les noms des acteurs principaux dans les éléments HTML prédéfinis
  movie_cast = movie_page %>%
    html_nodes(".meta-body-actor .dark-grey-link") %>%
    html_text() %>%
    paste(collapse = ",")
  # Retourne les noms des acteurs sous forme de chaîne de texte
  return(movie_cast)
}

get_gender = function(movies_link) {
  # Charge la page HTML du film correspondant à l'URL fournie
  movie_page = read_html(movies_link)
  # Extrait les genres associés au film
  movie_gender = movie_page %>%
    html_nodes(".meta-body-info .dark-grey-link") %>%
    html_text() %>%
    paste(collapse = ",")
  # Retourne les genres sous forme de chaîne de texte
  return(movie_gender)
}

#### Extraction des données Allociné

# Les sélecteurs CSS tels que ".meta-affinity-score .meta-title-link" ont été identifiés 
gratuitement à l'aide de l'extension Selector Gadget. Si l'extension ne fonctionne pas correctement,
le code HTML doit être inspecté manuellement via les outils de développement des navigateurs.

#Ici dans la boucle for on scrap 5 pages

for (page_result in seq(from = 1, to = 5, by = 1)) {
  # Construit l'URL pour chaque page à scraper
  link = paste("https://www.allocine.fr/films/?page=", page_result, sep = "")
  # Charge la page HTML de l'URL correspondante
  page = read_html(link)
Charge la structure HTML de la page.
  # Extraction des noms de films
  name = page %>%
    html_nodes(".meta-affinity-score .meta-title-link") %>%
    html_text() %>%
    str_trim()
la fonction html_node est un peu différentes (dans les autres autres cas on trouve html_nodes) enlever le "S" permet de ne récupérer que le premier élément ici la première note (il en existe 3 maximum pour le site ), la fonction html_node permet de scraper qu'une seule note sur les deux, ce qui était important pour garder une cohérence de taille dans le data.frame



  # Extraction des notes des films
  notes = page %>%
    html_node(".stareval-note") %>%
    html_text() %>%
    str_trim() %>%
    gsub(",", ".", .)

  # Affiche un message pour suivre la progression du scraping
  print(paste("Analyse de la page :", page_result))
}

#### Interface utilisateur (UI)

ui <- fluidPage(
  # Titre principal de l'application
  titlePanel("Recherche de Films"),
  # Mise en page avec panneau latéral pour les filtres
  sidebarLayout(
    sidebarPanel(
      # Champ pour définir la note minimale des films
      numericInput("min_note", "Note minimale :", value = NA, min = 0, max = 10, step = 0.1),
      # Champ pour définir la note maximale des films
      numericInput("max_note", "Note maximale :", value = NA, min = 0, max = 10, step = 0.1),
      # Champ pour entrer une année spécifique
      textInput("date", "Date (année) :", ""),
      # Champ pour filtrer par genre
      textInput("gender", "Genre :", ""),
      # Champ pour filtrer par acteur
      textInput("cast", "Casting :", ""),
      # Champ pour filtrer par réalisateur
      textInput("director", "Réalisateur :", "")
    ),
    # Panneau principal pour afficher les résultats
    mainPanel(
      DTOutput("filtered_movies")
    )
  )
)

#### Serveur (logique backend)

server <- function(input, output, session) {
  # Crée un objet réactif qui filtre les films selon les entrées utilisateur
  filtered_movies <- reactive({
    movies_data %>%
      filter(
        is.na(input$min_note) | note >= input$min_note,
        is.na(input$max_note) | note <= input$max_note,
        grepl(input$date, year, ignore.case = TRUE),
        grepl(input$gender, genre, ignore.case = TRUE),
        grepl(input$cast, cast, ignore.case = TRUE),
        grepl(input$director, director, ignore.case = TRUE)
      )
  })

  # Affiche les films filtrés dans un tableau interactif
  output$filtered_movies <- renderDT({
    datatable(filtered_movies(), options = list(pageLength = 10))
  })
}

#### Lancement de l'application

# Lance l'application Shiny avec l'interface utilisateur et la logique backend
shinyApp(ui, server)
