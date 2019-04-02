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
 
# faire une recherche

# va sur une page

remDr$navigate("https://www.leboncoin.fr/jardinage/offres/") 

recherchelbc.webElem <- remDr$findElement(using = "css", "input[value='']")
recherchelbc.webElem$sendKeysToElement(list("bois de chauffage", key = "enter"))

remDr$getCurrentUrl() # pour une verif
remDr$screenshot(display = TRUE)


# va sur une page specifique

remDr$navigate("https://www.leboncoin.fr/jardinage/1572758346.htm/") 

remDr$screenshot(display = TRUE)

# on va recup le code html
temp <- read_html(remDr$getPageSource()[[1]])

# il faut trouver le bon nodes, je tatonne encore un peu

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