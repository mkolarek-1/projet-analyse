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

#code avec TMDB
#lien du site a scrapper
#le genre du film n'apparait pas de base sur le site il faut cliquer d'abord sur le film chosit pour pouvoir le voir d'ou la création de movies_link et de get_gender
#qui permettent de cliquer sur le film et puis de séléctionner le genre du film ; la dernière partie de movie_gender permet de créer une colonne avec le genre
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
#utilisation d'une extension chrome  pour pouvoir sélectionner l'élément a scrapper sur la page puis transformation en texte

#récupération du nom du film
name = page %>% html_nodes(".meta-affintiy-score .meta-title-link") %>% html_text()%>% str_trim()
movies_link = page %>% html_nodes(".meta-affintiy-score .meta-title-link") %>% html_attr("href")  %>%
  paste("https://www.allocine.fr",.,sep="") 

#récupération de la note film, petit problème ici l'exentsion chrome n'arrivait a détécter que la balise "canva" mais qui ne permettait pas de récupérer
#la note du dit film, il a fallut fouiller un peu dans le code html pour trouver ou se trouvait la note du film

notes = page %>% 
  html_node(".stareval-note") %>%  # Cibler la balise 
  html_text() %>%                  # Extraire le texte
  str_trim() %>%                   # Supprimer les espaces inutiles
  gsub(",", ".", .)            # Remplacer la virgule par un point (pour les décimales)
  

#récupération de la date du film

date = page %>% html_nodes(".date") %>% html_text()%>% str_trim()
#récupération du genre du film

gender = sapply (movies_link, FUN = get_gender, USE.NAMES = FALSE)

#création d'un data frame contenant le nom, la note, la date et le ou les genres du film

movies = rbind(movies,data.frame( name , notes , date , gender ))

print(paste("page:",page_result))
}





