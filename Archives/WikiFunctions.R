library(readr)
library(stringr)
library(tidyverse)
library(udpipe)
library(corpus)
library(plyr)
ud_model <- udpipe_download_model(language = "english")
udmodel_english <- udpipe_load_model(ud_model$file_model)

cleaninterview <- function(interview) {
  interview %>% 
    tolower() %>%
    str_replace_all("ms.", "miss") %>%
    str_split("\\. | \\? | \\! ") %>%
    as.data.frame()
}

changecolname <- function(interview) {
  colnames(interview)[1] <- "sentences"
  interview$sentences <- as.character(interview$sentences)
  interview
}

getkeyphrases <- function(interview){
  s <- udpipe_annotate(udmodel_english, interview[[1]])
  x <- data.frame(s)
  phrases <- keywords_rake(x = x, term = "lemma", group = "doc_id", 
                           relevant = x$upos %in% c("NOUN", "ADJ"))
  #try other ways to get the phrases! Get more context here!
  phrases$key <- factor(phrases$keyword, levels = rev(phrases$keyword))
  top25phrases <- head(phrases$key, 25)
  listofphrases <- lapply(top25phrases, function(x){
    paste(x, collapse=" ")
  })
  dfphrases <- data.frame(theme = unlist(listofphrases)) %>%
    #Alphabetize
    aaply(1, sort) %>%
    as.data.frame() %>%
    t() %>%
    as.data.frame()
  return(dfphrases)
}

allphrases <- function(interviewfolder){
  interview_out <- rep(0, nrow(dat_word))
  
  for (i in 1:nrow(dat_word)) {
    cleandat <- changecolname(cleaninterview(dat_word$text[i]))
    output <- getkeyphrases(cleandat)
    interview_out[[i]] <- output
  }
  
  words <- as.data.frame(interview_out)
  colnames(words) <- as.vector(dat_word$doc_id)
  return(words)
}



