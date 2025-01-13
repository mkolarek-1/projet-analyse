
### code testé et validé pour les 46 premières pages
### Documentation détaillée du code

#### Chargement des bibliothèques
@@ -83,7 +84,7 @@
  str_trim()
```
Sélectionne les titres des films, puis supprime les espaces inutiles.
#### la fonction html_node est un peu différentes (dans les autres autres cas on trouve html_nodes) enlever le "S" permet de ne récupérer que le premier élément ici la première note (il en existe 3 maximum pour le site )
- **Note du film :**
```r
notes = page %>%
@@ -100,49 +101,50 @@
Utilisent des techniques similaires avec les fonctions définies.

---
### permet d'afficher un message a chaque page scraper
print(paste("analyse de la page:",page_result))
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
