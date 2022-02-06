# hint/cheat functions
# print_answers()
# print_hint_list()

#' Print all answers for a set of letters
#'
#' \code{print_answers} is a cheater function which identifies
#' all the possible answers for a set of given letters.
#'
#' These words may or may not be the same as those identified
#' with other word sets; you can modify by changing the chosen
#' dictionary. This function is called by
#' \code{\link{play_game}} when choosing to get all answers
#' (with "[a]" entered instead of a guess).
#'
#' This function will always check whether you \strong{really}
#' want to see the answers, requiring a "y" to continue.
#'
#' @param game_letters The letters to identify words from.
#'   These should be a character string (e.g., "polemic").
#'   (Required, if \code{game} is not provided.)
#' @param central The central (that is, required) letter
#'   (optional). If not provided, will be randomly chosen
#'   from among the \code{game_letters}.
#' @param num_letters The number of letters for the game;
#'   defaults to 7, and should be between 6 and 10.
#' @param min_word_length Expected length of words. Defaults
#'   to 4 letters, but can be between 2 and 6.
#' @param dictionary Character string. Choice of how detailed
#'   of a dictionary to use. Can be any of "slim", "broad",
#'   or "normal". Defaults to "normal", which is recommended.
#' @param obscenities Logical. Should obscenities be included?
#'   Defaults to FALSE.
#' @param game A \code{holoalphabetic} game from
#'   \code{\link{play_game}} or \code{\link{create_game}}.
#'   If included, no other parameters are required.
#' @param state State of a \code{holoalphabetic} game; provided
#'   from current gameplay.
#'
#' @return When called directly (or through gameplay), this
#'   prints the answers to all words possible.
#'
#' @examples
#' print_answers(game = create_game("craking"))
#' print_answers("balmntu")
#'
#' @seealso \code{\link{play_game}} to play the game
#' @seealso \code{\link{print_hint_list}} to get hints
#'   rather than answers
#'
#' @export
print_answers <- function(game_letters = NULL,
                          central = NULL,
                          num_letters = 7,
                          min_word_length = 4,
                          dictionary = "normal",
                          obscenities = FALSE,
                          game = NULL,
                          state = NULL) {
  if(! is.null(game$state)) {
    state <- game$state
    game <- game$game
    cat("Correctly guessed:", paste(state$correct), fill=TRUE)
    cat("Score: ", state$score, "/", sum(unlist(state$words)), fill=TRUE)
  }
  cat("Ready to see the full word list? Type a y if so!: ")
  answer_i <- tolower(readline(prompt="? "))
  if(is.null(game)) {
    game <- create_game(game_letters, central,
                        num_letters, min_word_length,
                        dictionary, obscenities)
  }
  if(answer_i == "y") {
    cat(paste0("The pangram",
               ifelse(length(game$pangram) == 1, " is:", "s are:")),
        paste(game$pangram, collapse = ", "), "\n\n")
    words <- names(game$scored_word_list)
    words <- words[ ! words %in% game$pangram]
    cat("The remaining words follow:\n",
        paste(sort(words), collapse = ", "))
    state$finished = TRUE
  } else {
    state$finished = FALSE
  }
  return(invisible(state))
}

#' Prints hints to help get all the answers
#'
#' \code{print_hint_list} is a helper function which identifies
#' the \strong{number} of words for the given set of letters,
#' and (if desired) identifies what letters (two or three)
#' words begin with.
#'
#' These words may or may not be the same as those identified
#' with other word sets; you can make minor changes
#' by changing the chosen
#' dictionary. This function is called by
#' \code{\link{play_game}} when choosing to get hints
#' (with "[h]" entered instead of a guess). You can choose
#' to get hints of the first two of three letters, or none.
#'
#' @param game_letters The letters to identify words from.
#'   These should be a character string (e.g., "polemic").
#'   (Required, if \code{game} is not provided.)
#' @param central The central (that is, required) letter
#'   (optional). If not provided, will be randomly chosen
#'   from among the \code{game_letters}.
#' @param num_letters The number of letters for the game;
#'   defaults to 7, and should be between 6 and 10.
#' @param min_word_length Expected length of words. Defaults
#'   to 4 letters, but can be between 2 and 6.
#' @param dictionary Character string. Choice of how detailed
#'   of a dictionary to use. Can be any of "slim", "broad",
#'   or "normal". Defaults to "normal", which is recommended.
#' @param obscenities Logical. Should obscenities be included?
#'   Defaults to FALSE.
#' @param game A \code{holoalphabetic} game from
#'   \code{\link{play_game}} or \code{\link{create_game}}.
#'   If included, no other parameters are required.
#' @param state State of a \code{holoalphabetic} game; provided
#'   from current gameplay.
#'
#' @return When called directly (or through gameplay), this
#'   prints hints to help you find all answers.
#'
#' @examples
#' print_hint_list(game = create_game("craking"))
#' print_hint_list("balmntu")
#'
#' @seealso \code{\link{play_game}} to play the game
#' @seealso \code{\link{print_answers}} to get all answers
#'
#' @importFrom stats addmargins
#' @export
print_hint_list <- function(game_letters = NULL,
                            central = NULL,
                            num_letters = 7,
                            min_word_length = 4,
                            dictionary = "normal",
                            obscenities = FALSE,
                            game = NULL,
                            hint = NULL) {
  if(! is.null(game$state)) {
    state <- game$state
    game <- game$game
    cat("Correctly guessed:", paste(state$correct), fill=TRUE)
    cat("Score: ", state$score, "/", sum(unlist(state$words)), fill=TRUE)
  }
  if(is.null(game)) {
    game <- create_game(game_letters, central,
                        num_letters, min_word_length,
                        dictionary, obscenities)
  }
  words <- names(game$scored_word_list)
  cat(
    paste0(
      "Words: ",
      length(words), ", ",
      "Pangram",
      ifelse(length(game$pangram) == 1, ": ", "s: "),
      length(game$pangram),
      ifelse(length(game$pangram) == 1, " (", " ("),
      sum(sapply(game$pangram, nchar) == 7),
      " perfect)."
    ),
    "\n")
  first_letters <- data.frame(
    first = stringr::str_sub(words, 1, 1),
    lengths = nchar(words)
  )
  chart <- addmargins(
    table(first_letters$first,
          first_letters$lengths)
  )
  print(chart,
        zero.print = "-",
        justify = "centre")
  # print out letter hints
  start_l <- unique(stringr::str_sub(words, 1, 1))
  cat(paste0("Would you like to see the first ",
             "two (type \'2\') or three (type \'3\') ",
             "letters of the words? \n If neither, just ",
             "hit enter.\n"))
  answer_i <- readline(prompt="? ")
  if(answer_i == "2") {
    two_l <- paste0(stringr::str_sub(words, 1, 1),
                    stringr::str_sub(words, 2, 2))
    for(l in start_l) {
      print(table(subset(two_l,
                         stringr::str_sub(two_l, 1, 1) == l)))
    }
  } else if(answer_i == "3") {
    three_l <- paste0(stringr::str_sub(words, 1, 1),
                      stringr::str_sub(words, 2, 2),
                      stringr::str_sub(words, 3, 3))
    for(l in start_l) {
      print(table(subset(three_l,
                         stringr::str_sub(three_l, 1, 1) == l)))
    }
  }
}
