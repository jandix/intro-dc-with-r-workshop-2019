# Install and load packages ----------------------------------------------------
# install legislatoR from github (requires devtools)
# install.packages("devtools")
# devtools::install_github("saschagobel/legislatoR")

# load packages
library(legislatoR)
library(dplyr)
library(readr)

# Load data set for recent legislation -----------------------------------------
# get core data set usa senate
politicians <- dplyr::semi_join(x = get_core(legislature = "usa_senate"),
                                y = dplyr::filter(get_political(legislature = "usa_senate"),
                                                  session == 115),
                                by = "pageid")

social_media <- dplyr::semi_join(x = get_social(legislature = "usa_senate"),
                                 y = politicians,
                                 by = "wikidataid")

political <- dplyr::semi_join(x = get_political(legislature = "usa_senate"),
                              y = politicians,
                              by = "pageid")

# Save data sets ---------------------------------------------------------------
# save politicians as csv
write.csv(politicians, file = "./data/senators.csv")

# save social media as csv
write.csv(social_media, file = "./data/social_media.csv")

# save political data as RDS
write_rds(political, path = "./data/political.rds")

