# creates or plays game
# create_game()
# play_game()
# and test_word()

# environment
# game_env <- new.env(parent = emptyenv())

# --------------------------------------------------------------
#' Set up a holoalphabetic game
#'
#' \code{create_game} defines the terms of the game, choosing letters that
#' contain a pangram (i.e., all of them are used together in at least one
#' English word). The function is called automatically by
#' \code{\link{play_game}}, which then interactively plays the game. However,
#' you can intentionally use \code{create_game} to save a set of words.
#'
#' Because of random sampling, it is possible that the internal function will
#' not find a set of letters with a pangram; if so, simply run the function
#' again.
#'
#' @param num_letters The number of letters for the game; defaults to 7, and
#'   should be between 6 and 10.
#' @param game_letters User-selected letters to use in the game (optional). Will
#'   result in a warning if more letters are chosen than \code{num_letters}. If
#'   including, this should be a character string, e.g., "stb".
#' @param min_word_length Expected length of words. Defaults to 4 letters, but
#'   can be between 2 and 6.
#' @param dictionary Character string. Choice of how detailed of a dictionary to
#'   use. Can be any of "slim", "broad", or "normal". Defaults to "normal",
#'   which is recommended.
#' @param obscenities Logical. Should obscenities be included? Defaults to
#'   FALSE.
#'
#' @return Regardless of whether you include any inputs, the function returns a
#'   game object \code{game} which can be used with \code{\link{play_game}}. The
#'   results of \code{create_game} should be assigned and used in
#'   \code{play_game}; running it on its own will have no effect.
#'
#' @examples
#' create_game()
#' create_game(num_letters = 6, game_letters = "s")
#' create_game(obscenities = TRUE)
#'
#' @seealso \code{\link{play_game}} to play the game
#'
#' @export
create_game <- function(num_letters = 7, game_letters = NULL, min_word_length = 4,
                 dictionary = "normal", obscenities = FALSE) {
  if( ! num_letters %in% c(6:10)) {
    warning(paste0("The game is meant to be played with between 6 and 10 letters. ",
                "Using the default of 7; please choose a number between 6 and 10."))
    num_letters <- 7
  }
  if( ! dictionary %in% c("normal", "broad", "slim")) {
    warning("The dictionary must be one of 'normal', 'slim', or 'broad'.")
    warning("Defaulting to 'normal'.")
    dictionary <- "normal"
  }

  dictionary <- switch(dictionary,
                       "slim" = slim,
                       "broad" = broad,
                       normal)

  if(obscenities) dictionary <- c(dictionary, profanities)

  user_game_letters <- game_letters
  user_num <- ifelse(length(user_game_letters) > 0, nchar(user_game_letters), 0)

  if(user_num >= num_letters & ! is.null(user_game_letters)) {
    warning("You provided more letters than the number for the game.")
    warning(paste0("Only ", num_letters, " will be chosen."))
  }

  if(min_word_length == 2) {
    warning("Including two-letter words may make the game quite cumbersome.")
  } else if(min_word_length < 2) {
    warning("Including one-letter words is not permitted; defaulting to four-letter word minimum.")
    min_word_length <- 4
  } else if(min_word_length > 6) {
    warning("This game can be close to impossible with only longer words... defaulting to four-letter word minimum.")
    min_word_length <- 4
  }
  if(min_word_length > num_letters) stop(
    paste0("Minimum word length can't be smaller than the number of ",
           "letters... even if you can imagine some words that would ",
           "make that work!"))
  game_letters <- choose_game_letters(game_letters = user_game_letters,
                            num_letters = num_letters)

  if( ! has_pangram(game_letters, dictionary) &
      user_num > num_letters - 1) {
    stop(paste0("There is unlikely to be a pangram with the chosen letters. ",
                "Consider selecting fewer must-have letters."))
  }

  check_counter <- 1
  while( ! has_pangram(game_letters, dictionary) &
         check_counter < 2000) {
    game_letters <- choose_game_letters(game_letters = user_game_letters,
                              num_letters = num_letters)
    check_counter <- check_counter + 1
  }
  if(! has_pangram(game_letters, dictionary)) {
    stop(paste0("Sorry, ",
                "no pangram was found. You may want to try again",
                ifelse(nchar(user_game_letters) > 0,
                       " with different or fewer letters.", ".")))
  }

  central_letter <- sample(game_letters, 1)

  word_list <- find_all_words(game_letters, min_word_length,
                              central_letter, dictionary)

  pangram <- which_pangram(word_list, game_letters)

  scored_word_list <- score_words(word_list, pangram)

  remaining_letters <- game_letters[central_letter != game_letters]

  game_obj <- structure(list(scored_word_list = scored_word_list,
                             game_letters = game_letters,
                             remaining_letters = remaining_letters,
                             central_letter = central_letter,
                             pangram = pangram,
                             min_word_length = min_word_length))
  # game_env$game <- game_obj
  return(invisible(game_obj))
}

# --------------------------------------------------------------
test_word <- function(input, game, state) {
  # only if input is not blank
  if(input != "") {
    state$counter = state$counter + 1
    # record the guess
    state$guesses[input] <- input
    # if input is contained in word list
    if( ! is.null(state$words[input][[1]])) {
      state$score <- state$score + state$words[input][[1]] # add to score
      state$correct <- c(state$correct, input)             # add to correct list
      if(input %in% game$pangram) cat("That's a pangram!\n") # if pangram, say so
      cat(state$words[input][[1]], "points!\n")
    } else { # if not in word list, test why... are letters correct, etc.
      not_letters <- paste0("[^", paste0(game$remaining_letters, collapse = ""),
                            game$central_letter, "]")
      if(stringr::str_detect(input, not_letters)) {
        cat("You've used letters not included in the options!\n")
      } else if(stringr::str_detect(input, game$central_letter, negate=TRUE)) {
        cat(paste0("You must use the central letter, ", game$central_letter, ".\n"))
      } else if(nchar(input) < game$min_word_length) {
        cat(input, "is shorter than the minimum word length!\n")
      } else {
        cat("No,", input, "isn't in the word list.\n")
      }
    }
  }
  if(length(state$correct) > 0) cat("Correctly guessed:",
                                    paste(state$correct),
                                    fill=TRUE)
  if(state$score > 0) cat("Score: ", state$score, "/",
                          sum(unlist(state$words)), fill=TRUE)
  if(state$score == sum(unlist(state$words))) {
    cat("You've correctly gotten all the words! Impressive! ")
    state$finished = FALSE
    return(state)
  }
  if(state$keep_central_first) {
    cat(paste("Letters:",
              toupper(game$central_letter),
              paste0(sample(game$remaining_letters), collapse=" ")
    ), fill = TRUE)
  } else{
    cat(paste("Letters:",
              paste0(sample(c(toupper(game$central_letter),
                            game$remaining_letters)),
                     collapse=" ")
    ), fill = TRUE)
  }
  return(state)
}

# --------------------------------------------------------------
#' Play the holoalphabetic game
#'
#' \code{play_game} provides an interactive interface for guessing words
#' based on a game made by \code{\link{create_game}}. If you call this function
#' directly, it will create the game itself. Assigning the results to a variable
#' will allow you to pause and continue the game later by running
#' \code{play_game(prev_game)}.
#'
#' @param game A game object created by \code{\link{create_game}}. If null, the
#'   default, \code{play_game} will create a new game object. Alternatively, if
#'   using a previous game, \code{game} will contain both the game and
#'   \code{state} variables.
#' @param keep_central_first Logical. Should the game always display the
#'   "central" letter first when printing the letters. Defaults to FALSE.
#' @param restart Logical. Only useful when trying anew with an existing game.
#'   Deletes previous guesses and starts with a clean slate, while using the
#'   same letters (and therefore words).
#' @param ... Arguments to pass to \code{\link{create_game}}, including
#'   \code{num_letters}, \code{game_letters}, \code{min_word_length},
#'   \code{dictionary}, and \code{obscenities}.
#'
#' @return Regardless of whether you include any inputs, the code will run a
#'   version of the game. If passed a game object from \code{create_game},
#'   the game will use the same letters and words. If passed a previously-played
#'   game from \code{play_game}, the game will pick up where you left off, and
#'   remind you of past guesses. Assign \code{play_game} to a variable to keep
#'   playing later.
#'
#' @examples
#' \dontrun{
#' play_game()
#'
#' # assuming a saved game called prev_game
#' play_game(game = prev_game)
#'
#' # permit obscenities
#' play_game(keep_central_first = TRUE,
#'           obscenities = TRUE)
#' }
#'
#' @seealso \code{\link{create_game}} to set up a game without playing.
#'
#' @export
play_game <- function(game = NULL,
                      keep_central_first = FALSE,
                      restart = FALSE,
                      ...) {
  # if the first argument includes a state, then divide it out
  if(! is.null(game$state)) {
    state <- game$state
    game <- game$game
    if(restart) {
      cat("You've restarted the game. Erasing your guesses and score.\n")
      state <- NULL
    } else{
      state$finished <- FALSE
      cat("You've resumed your game.\n")
      if(length(state$correct) > 0) cat("Correctly guessed:",
                                        paste(state$correct),
                                        fill=TRUE)
      if(state$score > 0) cat("Score: ", state$score, "/",
                              sum(unlist(state$words)), fill=TRUE)
    }
  } else {
    cat("If you'd like to see the rules, enter 'y' and then hit return.\n")
    cat("Otherwise, enter your first word or leave the line",
        "blank to reorder the letters.\n")
  }
  # if called directly, create a game first
  if(is.null(game)) {
    cat("Selecting letters!...")
    game <- create_game(...)
    }

  cat("Letters:", toupper(game$central_letter), game$remaining_letters, "\n")

  if(! exists("state")) {
    state <- list(counter = 1,
                  guesses = list(),
                  words = game$scored_word_list,
                  keep_central_first = keep_central_first,
                  correct = character(),
                  score = 0,
                  finished = FALSE)
  }

  while(! state$finished) {
    input <- tolower(readline(prompt="? "))
    input <- stringr::str_replace_all(input, "\\s+", "") # no whitespace
    state <- switch(
      input,
      "x" = {
        state$finished <- TRUE
        state
      },
      "exit" = {
        state$finished <- TRUE
        state
      },
      "y" = print_rules(game, state),
      "[g]" = all_guesses(state),
      "[a]" = print_answers(game, state),
      test_word(input, game, state)
      )
  }
  return(invisible(structure(list(game = game, state = state))))
}
