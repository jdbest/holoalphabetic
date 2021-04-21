# finds or checks for pangrams or other words


# --------------------------------------------------------------
#' Check to see if a set of words has a pangram
#'
#' Given a list of letters and a dictionary, is there a pangram?
#'
#' @param game_letters A character vector of letters in the format of
#'   c("l", "e", "t", "r", "s") or "letrs"
#' @param dictionary A character list of words---defaults to the normal list
#'   from the package.
#'
#' @return Logical: TRUE if a pangram exists; FALSE if not.
#'
#' @examples
#' has_pangram(c("l", "e", "t", "r", "s")) # yes
#' has_pangram(c("d", "r", "g", "t", "i")) # none
#' # or:
#' has_pangram("leters")
#'
#' @seealso \code{\link{find_all_words}}
#'
#' @export
has_pangram <- function(game_letters, dictionary = normal) {
  # make sure letters are in right format
  game_letters <- tolower(game_letters)
  if(length(game_letters) == 1) {game_letters <- unlist(strsplit(game_letters, ""))}
  # include only words that start with our letters,
  # use only them, and end with them
  any_pattern <- paste0("^[", paste0(game_letters, collapse=""), "]+$")
  all_words <- stringr::str_subset(string = dictionary,
                                   pattern = any_pattern)
  # loop to make sure *each* letter is included
  pangramwords <- all_words
  for(l in game_letters) {
    pangramwords <- stringr::str_subset(string = pangramwords,
                                        pattern = l)
  }
  if(length(pangramwords) == 0) return(FALSE) else return(TRUE)
}

# --------------------------------------------------------------
#' Find all words in a given set of letters.
#'
#' Given a list of letters and a dictionary, what are all plausible
#' combinations to create English words?
#'
#' @param game_letters A character vector of letters. Should either be in the
#'   format of c("l", "e", "t", "r", "s") or simply "letrs".
#' @param min_word_length The minimum required word length; defaults to 4.
#' @param central_letter The game expects a "central" letter; what is that?
#'   Expects a single character, e.g., "c"---if none is provided, defaults to
#'   the first letter of \code{game_letters}.
#' @param dictionary A character list of words---defaults to the normal list
#'   from the package.
#'
#' @return A character vector of words in the form of c("first", "second", "third")
#'
#' @examples
#' # all words using the letters letrs that include an l and are at least
#' # 4-letters long.
#' find_all_words(c("l", "e", "t", "r", "s"))
#' # all words using the letters drgti that are at least 3-letters long
#' find_all_words("drgti", min_word_length = 3)
#'
#' @seealso \code{\link{has_pangram}}
#'
#' @export
find_all_words <- function(game_letters,
                           min_word_length = 4,
                           central_letter,
                           dictionary = normal) {
  game_letters <- tolower(game_letters)
  if(length(game_letters) == 1) {game_letters <- unlist(strsplit(game_letters, ""))}
  if(missing(central_letter)) central_letter <- game_letters[1]
  all_words <- stringr::str_subset(
    string = dictionary,
    pattern = central_letter
  )
  patterned <- paste0("^[", paste0(game_letters, collapse=""), "]+$")
  all_words <- stringr::str_subset(
    string = all_words,
    pattern = patterned
  )
  # include only words longer than the minimum # of letters
  all_words <- all_words[nchar(all_words) >= min_word_length]
  return(all_words)
  # would sort in order of length:
  # all_words <- all_words[order(nchar(all_words), all_words)]
  # paste0(rep(patterned, num_letters), collapse="")
}


# not exported -- requires word_list
which_pangram <- function(word_list, game_letters) {
  pangramwords <- word_list
  # loop through to detect pangram
  for(l in game_letters) {
    pangramwords <- stringr::str_subset(string = pangramwords, pattern = l)
  }
  pangramwords
}
