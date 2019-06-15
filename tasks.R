# Aufgaben 1 -------------------------------------------------------------------

## 1. Erstelle einen Vektor k mit den Werten 1, 32, 76, 12 und 45.

numbers <- c(1, 32, 76, 12, 45)

## 2. Schreibe eine For-Schleife, die die Quadratwurzeln (sqrt()) des Vektors k ausgibt.

for (number in numbers) {
  print(sqrt(number))
}

## 3. Erweitere die For-Schleife aus 2. folgendermaßen: Ist die Quadratwurzel
#     kleiner als 5, so gebe hello world aus , andernfalls HELLO WORLD.

for (number in numbers) {
  if (sqrt(number) < 5) {
    print("hello world")
    
    
  }
  else{
    print("HELLO WORLD")
  }
}



## 4. Nutze nun die vektorisierte Form (ifelse), um den Vektor m zu erstellen:
#     Ist k^2 größer als 267.4, so soll m k^2 annehmen, andernfalls -3.



## 5. FÜhre die Aufgabe aus 4 nun in einer For-Loop durch

m <- ifelse(numbers ^ 2 > 267.4, numbers ^ 2,-3)

x <- c()
for (number in numbers) {
  if (number ^ 2 > 267.4) {
    x <- c(x, number ^ 2)
  } else {
    x <- c(x,-3)
  }
}


# Aufgaben 2 -------------------------------------------------------------------

# Load libs
library(readr)
library(readxl)


## 1. Lese den Datensatz senators.csv ein und speicher den Datensatz in der Variable senators.

senators <- read_csv("data/senators.csv")

## 2. Lese den Datensatz social_media.xls ein und speicher den Datensatz in der Variable social_media.

social_media <- read_xls("data/social_media.xls")

## 3. Lese den Datensatz political.rds ein und speicher den Datensatz in der Variable political.

political <- read_rds("data/political.rds")


# Aufgaben 3 -------------------------------------------------------------------

# Load packages
library(newsanchor)

## 1. Suche nach den US-amerikanischen Zeitungen, die mit der News API verfügbar sind.

# NEEDS API KEY IN YOUR .Renviron !!!

# get all sources for country us
sources <- newsanchor::get_sources(country = "us")

# Extract results_df
us_sources <-  sources$results_df

## 2. Wähle die drei größten Tageszeitungen aus und suche die entsprechenden Synonyme im newsanchor package raus.

famous_newspapers <-
  c("the-wall-street-journal", "the-new-york-times", "usa-today")


## 3. Wähle eine:n Politiker:in aus dem senators Datensatz und suche alle verfügbaren Artikeln in
#     englischer Sprache innerhalb der gewählten Tageszeitungen raus zwischen dem 03. Juni und dem 09. Juni.
#     Speicher den result_df unter my_favourite_senator ab ! Wir werden ihn später brauchen …

# random pick

set.seed(11)
random_index <- sample.int(nrow(senators), 1)
my_senator <- senators$name[random_index]

#
my_favourite_senator <-
  newsanchor::get_everything_all(
    query = my_senator,
    sources = famous_newspapers,
    from = "2019-06-03",
    to = "2019-06-09"
  )
my_favourite_senator <- my_favourite_senator$results_df


# Aufgaben 4 -------------------------------------------------------------------


## 1. Lade die Tabelle über alle Senatoren des 115. Senats herunter https://en.wikipedia.org/wiki/List_of_members_of_the_United_States_Senate

# package laden
library(htmltab)

# URL definieren
url <-
  "https://en.wikipedia.org/wiki/List_of_members_of_the_United_States_Senate"

# tabelle herunterladen
senate <- htmltab(url, which = 5)


## 2. Lade den Artikel https://www.nytimes.com/2019/06/14/world/middleeast/oil-tanker-attack-gulf-oman.html
#     herunter und extrahiere den Text mit Hilfe von rvest.

library(rvest)

# webiste herunterladen
news_article <-
  read_html(
    "https://www.nytimes.com/2019/06/14/world/middleeast/oil-tanker-attack-gulf-oman.html "
  )

# cast parsen
raw_text <- html_nodes(news_article, ".StoryBodyCompanionColumn")
raw_text <- html_text(raw_text)

clean_text <- paste(raw_text, collapse = " ")


# Aufgaben 5 -------------------------------------------------------------------

# package laden
library(dplyr)

# join senators und political
senators_complete <- left_join(senators, political, by = "pageid")

# join senators und social media
senators_complete <-
  left_join(senators_complete, social_media, by = "wikidataid")

# Aufgaben 6 -------------------------------------------------------------------

# packages laden
library(httr)
library(jsonlite)

label_image <- function (image_url) {
  # url definieren
  url <- "https://imagenet.pbehrendt.eu"
  
  # url parsen
  url <- httr::parse_url(url)
  
  # add query
  url$query <- list(url = image_url)
  
  # build url
  url <- httr::build_url(url)
  
  # "get" anfrage senden
  response <- httr::GET(url)
  
  # check anfrage
  if (httr::http_error(response)) {
    return(NA)
  }
  
  # parse content
  content <- httr::content(response, type = "text")
  parsed_content <- jsonlite::fromJSON(content)
  
  return(parsed_content)
}

# test manually 
my_labels <- label_image(image_url =  "https://static01.nyt.com/images/2019/06/07/opinion/07Egan/07Egan-facebookJumbo.jpg")
my_labels


# Fill a vector
image_labels <- c()

for (image in my_favourite_senator$url_to_image) {
  results <- label_image(image_url = image)
  if (all(is.na(results))) {
    image_labels <- c(image_labels, NA)
  } else {
    image_labels <- c(image_labels, results$class_description[1])
  }
}

my_favourite_senator <- cbind(my_favourite_senator, image_labels)
  
  
  
  
