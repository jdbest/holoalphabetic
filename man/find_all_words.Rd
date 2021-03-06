% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/word_finders.R
\name{find_all_words}
\alias{find_all_words}
\title{Find all words in a given set of letters.}
\usage{
find_all_words(
  game_letters,
  min_word_length = 4,
  central_letter,
  dictionary = normal
)
}
\arguments{
\item{game_letters}{A character vector of letters. Should either be in the
format of c("l", "e", "t", "r", "s") or simply "letrs".}

\item{min_word_length}{The minimum required word length; defaults to 4.}

\item{central_letter}{The game expects a "central" letter; what is that?
Expects a single character, e.g., "c"---if none is provided, defaults to
the first letter of \code{game_letters}.}

\item{dictionary}{A character list of words---defaults to the normal list
from the package.}
}
\value{
A character vector of words in the form of c("first", "second", "third")
}
\description{
Given a list of letters and a dictionary, what are all plausible
combinations to create English words?
}
\examples{
# all words using the letters letrs that include an l and are at least
# 4-letters long.
find_all_words(c("l", "e", "t", "r", "s"))
# all words using the letters drgti that are at least 3-letters long
find_all_words("drgti", min_word_length = 3)

}
\seealso{
\code{\link{has_pangram}}
}
