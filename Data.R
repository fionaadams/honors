library(readr)
library(stringr)
library(tidyverse)
library(udpipe)
library(corpus)
library(plyr)
source("Functions.R")

AndrewTuttle <- read_delim("AndrewTuttle.txt", 
                           "^", escape_double = FALSE, trim_ws = TRUE, col_names=FALSE)
MarvinSeppala <- read_delim("MarvinSeppalaPart1.txt", 
                            "^", escape_double = FALSE, trim_ws = TRUE, col_names=FALSE)
ud_model <- udpipe_download_model(language = "english")
udmodel_english <- udpipe_load_model(ud_model$file_model)

#Clean dataset
CleanTuttle <- changecolname(cleaninterview(AndrewTuttle))
CleanSeppala <- changecolname(cleaninterview(MarvinSeppala))

#Get list of phrases
tuttlephraselist <- getkeyphrases(CleanTuttle)
seppalaphraselist <- getkeyphrases(CleanSeppala)
