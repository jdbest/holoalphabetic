# helper functions
# choose_game_letters()
# score_words()
# print_rules()
# all_guesses()

choose_game_letters <- function(game_letters = NULL, num_letters = NULL) {
  # vowels <- c("a", "e", "i", "o", "u")
  # consonants <- c("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p",
  #                 "q", "r", "s", "t", "v", "w", "x", "y", "z")
  if( ! is.null(game_letters)) {
    game_letters <- tolower(game_letters)
    # divide up
    game_letters <- unique(substring(game_letters,
                                     1:nchar(game_letters),
                                     1:nchar(game_letters)))
    game_letters <- game_letters[game_letters %in% letters]
    if(num_letters < length(game_letters)) {
      game_letters <- sample(game_letters, size = num_letters)
    } else if(num_letters > length(game_letters)) {
      game_letters <- c(game_letters,
                        sample(
                          x = letters[! letters %in% game_letters],
                          size = num_letters - length(game_letters)
                        )
      )
    }
  } else {
    # choose totally new game_letters
    game_letters <- sample(x = letters, size = num_letters)
  }
  # make sure there's at least one vowel:
  vowel <- c("a", "e", "i", "o", "u")
  if(! any(vowel %in% game_letters)) {
    game_letters[sample(1:length(game_letters), 1)] <- sample(vowel, 1)
  }
  return(game_letters)
}


score_words <- function(word_list, pangram, num_letters) {
  scores <- ifelse(nchar(word_list) <= 4, 1, nchar(word_list))
  # rescore to 15 if pangram (unless real word is longer)
  scores[word_list %in% pangram] <- ifelse(
    nchar(word_list[word_list %in% pangram]) > 15,
    nchar(word_list[word_list %in% pangram]),
    15
  )
  scored_word_list <- stats::setNames(as.list(scores), word_list)
  scored_word_list
}

print_rules <- function(game, state) {
  cat(paste0("For each game, you'll be presented with a set of letters, ",
             "usually seven (unless you choose otherwise). ",
             "Your job is to think of as many words as possible that use ",
             "those letters. There are two wrinkles: \n\n",
             "ONE: every word must include the letter that is currently first -- ",
             "it will move, but it will always be capitalized. \n",
             "TWO: in every set, there is at least one word that is a 'pangram'",
             " or holoalphabetic word, meaning that it uses all of the ",
             "available letters. You don't need to find it, but it's a fun ",
             "challenge. \n\n",
             "Words must have at least four letters unless you select ",
             "otherwise. Above four letters, you'll receive more points ",
             "the more letters your word has. \n\nDon't forget that ",
             "you can always quit with ESC or by hitting just an 'x', ",
             "or rearrange the ",
             "letters by not typing anything and hitting enter. Want to see all",
             " of the answers? Type [a] (brackets included). You can also get hints by typing [h]. You can always ",
             "review the rules by typing y... or see past guesses with [g]\n\n",
             "Ready to go? ",
             "Guess your first word. \n\nThe letters: ",
             toupper(game$central_letter), " ",
             paste0(sample(game$remaining_letters), collapse=" ")))
  return(state)
}

all_guesses <- function(state) {
  cat("You've guessed", state$counter, "times: \n\n",
      paste(state$guesses, collapse = ", "), "\n")
  return(state)
}
