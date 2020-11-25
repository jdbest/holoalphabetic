# holoalphabetic: Interactive pangram word games

This is a series of R functions written to create "pangram" wordgames. A pangram or holoalphabetic sentence is one which uses every letter of the alphabet, e.g., "Sphinx of black quartz, judge my vow." (Or, more famously, "The quick brown fox jumps over the lazy dog.") In the context of this game, however, the word game is limited to 6--10 letters (defaulting to 7). For example, the letters l, a, h, t, o, m, and b can form 46 words of at least four letters, of which the only pangram (using all seven letters) is "mothball".

The game requires you to use **one letter** in every word---for example, *m* might be required, meaning that "moth" would be an acceptable word, but "loath" would not be.

The R functions have been written to create an interactive game, meaning that you can guess words and receive points for each word.

The game is inspired by the New York Times' "[Spelling Bee](https://www.nytimes.com/puzzles/spelling-bee)," and uses word lists from the [Spell Checking Oriented Word Lists](http://wordlist.aspell.net/scowl-readme) (SCOWL) by Kevin Atkinson.

## Installation

In R, you can install directly from github:

```
# if needed: install.packages("devtools")
devtools::install_github("jdbest/holoalphabetic")
```

## Playing the game

The most direct way to play the game is just running the function `play_game()`:

```{r}
library(holoalphabetic)
play_game()
```

However, if you think you may want to play the game a bit at a time, you may assign the game's data to a variable, and then reuse it:

```
game1 <- play_game()
game1 <- play_game(game1)
```

You may always exit the game by typing an `x` in the Console; doing so will save your data. Note that using the ESC key will **not** result in your data saving. 

## Other functions

### `create_game()`

The function `create_game()` is called by `play_game()` to make a new pangram; you may choose to create multiple games all at once, and access just the letters from the resulting object, e.g.:

```
letter_list <- create_game()
letter_list$game_letters
```

The `create_game()` function chooses letters at random unless you request otherwise; as a result, it occasionally will take some time until it identifies letters that can form a pangram.

### `find_all_words()` and `has_pangram()`

The function `find_all_words()` takes a string of letters and attempts to identify words that use any combination of them. By default, all words will use the first letter as the central one; you can change this argument. 

The function `has_pangram()` takes a vector of separated letters and simply identifies whether a pangram exists. This is particularly useful if you're doubting yourself! It intentionally does *not* tell you what the pangram is, however.

```
find_all_words("jutis")
has_pangram("jutis")
```

