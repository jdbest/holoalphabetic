# holoalphabetic: Interactive pangram word games

This is a series of R functions written to create "pangram" wordgames. A pangram or holoalphabetic sentence is one which uses every letter of the alphabet, e.g., "Sphinx of black quartz, judge my vow." (Or, more famously, "The quick brown fox jumps over the lazy dog.") In the context of this game, however, the word game is limited to 6--10 letters (defaulting to 7). For example, the letters l, a, h, t, o, m, and b can form 46 words of at least four letters, of which the only pangram (using all seven letters) is "mothball".

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
