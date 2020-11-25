# holoalphabetic: Updates

## 0.1.1, 11-25-2020

* Updated function to find pangram so that it uses regular expressions first and then loops after; microbenchmarking using `bench::mark()` suggests this slightly reduces the time for creating a new game, and substantially reduces the amount of garbage collection that R needs to do

## 0.1.0, 11-24-2020

* Pushed working package to github
