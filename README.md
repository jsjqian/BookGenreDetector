# Book Genre Detector
## How to run:
./book_genre_detector.rb books.json keywords.csv

Make sure Ruby is installed and the JSON and CSV packages are available.

# Trade-offs and edge cases
## Trade-offs
While trying to come up with an efficient way of creating the program, there
wasn't exactly a nice way of doing it besides going through the keywords list
with each of the books and calculating the scores that way. With many books and
a large keyword list, this script could take a long time to process everything.
Also, since Ruby is an interpreted language, it would have a longer run-time
than if it were written in a compiled language. However, I felt that since this
was a relatively basic task, it was worthwhile to trade efficiency for easier
development.

## Edge cases
There are some interesting edges cases that I tried to resolve in my own way and
there are some that I felt like were a little extreme but still worth
considering:
### 1. More than 3 genres with high scores
If there was a tie for the third highest genre, I ended up picking the one that
came first alphabetically.
### 2. Integer vs Float
In some cases, the scores could be different if floats were used instead of
integers. In order to maintain the precision of the scores, they were only
converted back to integers when it was time to display the results. That means
if there was a score of 10.5 and 10.2 that were vying for first, 10.5 would
be displayed first as 10 and then 10.2 as 10. This would put them out of
alphabetical order but would be more accurate as to which genre was higher.
### 3. Incorrect input
I did not really check for incorrect input other than making sure the input
files were JSON and CSV. If a title or description is missing, that is up to the
user to find and fix. If a keyword entry did not follow the string, string, int
format, then that would also be something the user would have to try to fix. For
cases like making a keyword "" or setting a keyword's value to 0, the program 
would still run but I cannot imagine a case where having values like those would
be an accurate calculation of a book's genre.

# Time spent
About two hours to get the basic functionality down and another hour to clean it
up a little bit and document everything.
