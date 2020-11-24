files <- list.files("./data-raw")
filenames <- tibble(
  files = files,
  names = c("words_10", "words_20", "words_35", "words_40",
            "words_50", "words_55", "words_60", "words_70", "words_80")
)

for(file in list.files("./data-raw")) {
  words <- read_csv(paste0("data-raw/", file), col_names = FALSE)
  words <- words$X1
  words <- words[stringr::str_detect(words, "'", negate=TRUE)]
  newname <- filenames[files == file,]$names
  print(newname)
  assign(newname, words)
}


words_80 <- words


slim <- c(words_10, words_20, words_35, words_40)
normal <- c(words_10, words_20, words_35, words_40, words_50, words_55, words_60)
broad <- c(words_10, words_20, words_35, words_40, words_50,
           words_55, words_60, words_70, words_80)
profane <- profanities


usethis::use_data(alphabet, slim, normal, broad, profanities, internal=TRUE)



