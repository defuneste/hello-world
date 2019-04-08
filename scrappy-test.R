library(RSelenium)
library(rvest)
library(xml2)
library(tidyverse)

## docker à mettre dans un shell
# docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
# docker ps

# connection
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)

# ouverture
remDr$open()
 
#### faire une recherche

### va sur une page

remDr$navigate("https://www.leboncoin.fr/jardinage/offres/") 

recherchelbc.webElem <- remDr$findElement(using = "css", "input[value='']")
recherchelbc.webElem$sendKeysToElement(list("bois de chauffage", key = "enter"))

remDr$getCurrentUrl() # pour une verif
remDr$screenshot(display = TRUE)


# on va recup le code html
temp <- read_html(remDr$getPageSource()[[1]])

# un test sur une page d'annonce

titre <- temp %>%
  rvest::html_nodes("p._2tubl") %>%
  rvest::html_text()

prix <- temp %>% # le prix n'est pas obligatoire donc pas toujours indiqué 
  rvest::html_nodes("div._2OJ8g") %>%
  rvest::html_text()

localisation <- temp %>%
  rvest::html_nodes("p._2qeuk") %>%
  rvest::html_text()

lien <- temp %>%
  rvest::html_nodes("a.clearfix.trackable") %>%
  rvest::html_attr( "href") %>%

boisbrute <- data_frame(titre, localisation)  
boisbrute <- boisbrute %>%
  mutate(lien = paste0("https://www.leboncoin.fr",lien))

# on va faire un fonction qui prend toute les pages

listehtml <- list()

navigation <- function(lienhref) { # prend un href 
  remDr$navigate(lienhref)     # va dessus
  listehtml <- read_html(remDr$getPageSource()[[1]]) # sauve dans une liste
}

page_annonce <- lapply(boisbrute$lien, navigation)

# fonction titre pour verifier

titre_annonce <- function(une_page) {
  une_page %>%
    rvest::html_nodes("h1._1KQme") %>%
    rvest::html_text()
}

lapply(page_annonce, titre_annonce)

boisbrute$titre

localisation_annonce <- function(une_page) { 
  une_page %>%
  rvest::html_nodes("div._1aCZv") %>%
  rvest::html_text() %>%
  str_remove("Voir sur la carte")
}

lapply(page_annonce, localisation_annonce)

# recup toutes les html d'une page
html_attr(html_nodes(temp, "a"), "href")

# il faut trouver le bon nodes, je tatonne encore un peu

# va sur une page specifique

remDr$navigate(boisbrute$lien[1]) 

class(boisbrute$lien[1])

remDr$screenshot(display = TRUE)

# titre
titre <- temp %>%
  rvest::html_nodes("h1._1KQme") %>%
  rvest::html_text()

# prix
prix <- temp %>%
  rvest::html_nodes("span._1F5u3") %>%
  rvest::html_text()

prix[1]

# date 

date<- temp %>%
  rvest::html_nodes("div._14taM") %>%
  rvest::html_children() %>%
  rvest::html_text()[3]

# text
texte <- temp %>%
  rvest::html_nodes("span.content-CxPmi") %>%
  rvest::html_text()

localisation <- temp %>%
  rvest::html_nodes("div._1aCZv") %>%
  rvest::html_text() %>%
  str_remove("Voir sur la carte")


vendeur <- temp %>%
  rvest::html_nodes("div._2zgX4") %>%
  rvest::html_children() %>%
  rvest::html_text()


class(remDr$getPageSource()[[1]])