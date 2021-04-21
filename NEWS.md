# holoalphabetic 0.1.3

* Included full parameters for `create_game()` in the `play_game()` function
* Added {pkgdown} website to github pages

# holoalphabetic 0.1.2

* Included option to specify the "central" letter in creating a game
* Fixed bug where a warning would be posted if `num_letters == nchar(game_letters)`; it should only be if `num_letters > nchar(game_letters)`

# holoalphabetic 0.1.1

* Updated function to find pangram so that it uses regular expressions first and then loops after; microbenchmarking using `bench::mark()` suggests this slightly reduces the time for creating a new game, and substantially reduces the amount of garbage collection that R needs to do

# holoalphabetic 0.1.0

* Pushed working package to github
