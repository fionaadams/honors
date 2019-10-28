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
  phrases$key <- factor(phrases$keyword, levels = rev(phrases$keyword))
  top25phrases <- head(phrases$key, 25)
  stemmedphrases <- text_tokens(top25phrases, stemmer = "en")
  listofphrases <- lapply(stemmedphrases, function(x){
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
