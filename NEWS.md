# holoalphabetic 0.1.4

* Added a `print_hint_list()` function to print hints while playing, including both first two letters and first three letters
* Made `print_hint_list()` and `print_answers()` into exported functions that can be called to check on outside games

# holoalphabetic 0.1.3

* Included full parameters for `create_game()` in the `play_game()` function
* Added {pkgdown} website to github pages
* Stopped score from incrementing when you guess the same thing again
* Fixed `restart = TRUE` argument for `play_game()`
* Fix `has_pangram()` for manual call, so that it can be used with a single string of characters (e.g., `has_pangram("jutis")` rather than only `has_pangram(c("j", "u", "t", "i", "s"))`)

# holoalphabetic 0.1.2

* Included option to specify the "central" letter in creating a game
* Fixed bug where a warning would be posted if `num_letters == nchar(game_letters)`; it should only be if `num_letters > nchar(game_letters)`

# holoalphabetic 0.1.1

* Updated function to find pangram so that it uses regular expressions first and then loops after; microbenchmarking using `bench::mark()` suggests this slightly reduces the time for creating a new game, and substantially reduces the amount of garbage collection that R needs to do

# holoalphabetic 0.1.0

* Pushed working package to github
