library(RSelenium)
library(rvest)
library(xml2)
library(tidyverse)


# docker
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)


remDr$open()

# va sur une page

remDr$navigate("https://www.leboncoin.fr/jardinage/1572758346.htm/") 

remDr$screenshot(display = TRUE)

# on va recup le code html
temp <- read_html(remDr$getPageSource()[[1]])

# il faut trouver le bon nodes, je tatonne encore un peu

titre <- temp %>%
  rvest::html_nodes("h1._1KQme") %>%
  rvest::html_text()


prix <- temp %>%
  rvest::html_nodes("span._1F5u3") %>%
  rvest::html_text()

prix[1]

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