### Documentation détaillée du code

#### Chargement des bibliothèques
```r
library(rvest)   # Permet d'extraire des données de pages web en HTML.
library(dplyr)   # Facilite la manipulation et le filtrage des données.
library(shiny)   # Crée une interface utilisateur interactive.
library(DT)      # Gère les tableaux dynamiques pour Shiny.
```
- **`rvest`** : Utilisé pour extraire et manipuler des éléments HTML spécifiques des pages web. Par exemple, pour scrapper des données comme les notes ou le casting des films.
- **`dplyr`** : Simplifie la manipulation des tableaux de données, notamment pour le filtrage et le tri.
- **`shiny`** : Permet de concevoir une interface web interactive avec des panneaux et des entrées dynamiques.
- **`DT`** : Utilisé pour afficher des tableaux interactifs dans une application Shiny.

---

#### Définition des fonctions pour scrapper des données
#### On peut aussi constater que les fonctions get_*** sont en dehors de la boucle "for" pour éviter que toutes ces fonctions se remettent à jour à chaque lancement de la boucle
##### Fonction `get_director`
```r
get_director = function(movies_link) {
  movie_page = read_html(movies_link) # Charge la page HTML du film.
  movie_director = movie_page %>%
    html_nodes(".meta-body-info+ .meta-body-oneline .dark-grey-link") %>%
    html_text() %>%
    paste(collapse = ",")
  return(movie_director)
}
```
- **`movies_link`** : URL du film à analyser.
- **`read_html`** : Charge la structure HTML de la page.
- **`html_nodes`** : Sélectionne les balises HTML contenant les informations des réalisateurs.
- **`html_text`** : Extrait le texte brut des balises sélectionnées.
- **`paste(collapse = ",")`** : Combine plusieurs réalisateurs en une seule chaîne de texte, séparée par des virgules.

##### Fonction `get_cast`
```r
get_cast = function(movies_link) {
  movie_page = read_html(movies_link)
  movie_cast = movie_page %>%
    html_nodes(".meta-body-actor .dark-grey-link") %>%
    html_text() %>%
    paste(collapse = ",")
  return(movie_cast)
}
```
- Fonctionnement similaire à `get_director`, mais pour le casting des films.

##### Fonction `get_gender`
```r
get_gender = function(movies_link) {
  movie_page = read_html(movies_link)
  movie_gender = movie_page %>%
    html_nodes(".meta-body-info .dark-grey-link") %>%
    html_text() %>%
    paste(collapse = ",")
  return(movie_gender)
}
```
- **`get_gender`** collecte les genres associés à un film, en utilisant une logique semblable à celle des fonctions précédentes.

---
#### les différents liens qui ressemble à ".meta-affintiy-score .meta-title-link" sont trouvé à l'aide d'une extension chrome du nom de selector gadget qui permet de trouver dans le code html les éléments utiles, mais parfois cette extension ne sélectionne pas le bon élément ( seulement un élément estéthique ) , il faut donc aller dans "inspecter" (avec clic droit) et fouiller soit même le code de la page pour trouver le bon élément
#### Boucle pour extraire les données des pages Allociné
```r
for (page_result in seq(from=1, to=5, by=1)) {
  link = paste("https://www.allocine.fr/films/?page=", page_result, sep="")
  page = read_html(link)
  ...
}
```
- **`seq(from=1, to=5, by=1)`** : Parcourt les pages 1 à 5 du site Allociné.
- **`paste`** : Construit l’URL complète pour chaque page.
- **`read_html(link)`** : Charge la structure HTML de la page.

##### Extraction des informations
- **Nom du film :**
```r
name = page %>%
  html_nodes(".meta-affintiy-score .meta-title-link") %>%
  html_text() %>%
  str_trim()
```
Sélectionne les titres des films, puis supprime les espaces inutiles.

- **Note du film :**
```r
notes = page %>%
  html_node(".stareval-note") %>%
  html_text() %>%
  str_trim() %>%
  gsub(",", ".", .)
```
### la fonction html_node permet de scraper qu'une seule note sur les deux, ce qui était important pour garder une cohérence de taille dans le data.frame
- **`gsub(",", ".", .)`** : Convertit les notes au format numérique en remplaçant les virgules par des points.

- **Date et genre :**
Utilisent des techniques similaires avec les fonctions définies.

---

#### Interface utilisateur (UI)
```r
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
```
- **`numericInput`** : Crée une entrée pour des valeurs numériques (ex. : notes minimales et maximales).
- **`textInput`** : Permet de saisir du texte pour des critères comme la date, le genre, ou le réalisateur.
- **`DTOutput`** : Affiche le tableau dynamique filtré.

---

#### Serveur (logique backend)
```r
server <- function(input, output, session) {
  ...
  output$filtered_movies <- renderDT({
    datatable(filtered_movies(), options = list(pageLength = 10))
  })
}
```
- **`reactive`** : Filtre les données dynamiquement en fonction des entrées utilisateur.
- **`datatable`** : Transforme les données filtrées en un tableau interactif.

---

#### Lancement de l'application
```r
shinyApp(ui, server)
```
- Cette ligne exécute l'application avec l'interface utilisateur (`ui`) et le serveur (`server`).
