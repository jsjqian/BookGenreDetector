#!/usr/bin/env ruby

require 'json'
require 'csv'

#################################
# Written by Jack Qian @jsjqian #
#################################

# The purpose of this script is to associate genres with a list of books
# given a JSON file of books and a CSV file of values associated with certain
# words.

# Checking for proper arguments
if (ARGV[0] == nil || ARGV[1] == nil) then
  puts "Missing arguments."
  puts "Expected format: \".book_genre_detector.rb <books.json> <genres.csv>\""
  exit
end

# First argument must be a JSON file
if (!(/.json/.match(ARGV[0]))) then
  puts "Error: " + ARGV[0] + " is not a JSON file."
  exit
end

# Second argument must be a CSV file
if (!(/.csv/.match(ARGV[1]))) then
  puts "Error: " + ARGV[1] + " is not a CSV file."
  exit
end

#######################
# Reading input files #
#######################

# Reading JSON for books
books = File.read(ARGV[0])
books_hash = JSON.parse(books)

# Reading CSV for genres
genre_values = CSV.read(ARGV[1])
genre_values.shift # Remove the first row
genre_values.each do |row|
  row[1].strip!
  row[2].strip!
end

#################################
# Book class for storing values #
#################################

class Book
 
  @title
  @description
  @genres = {}

  # Creates the book with a title and empty hash of genres
  def initialize(title, description)
    @title = title
    @description = description
    @genres = {}
  end

  # Add a genre and its score to the hash
  def add_genre(genre, score)
    @genres[genre] = score
  end

  # Calculate the top 3 genres
  def top_genres
    scores = @genres.values 
    scores.sort!.reverse!
    top_scores = scores.first(3) # Get the top 3 scores
    sorted_genres = @genres.keys.sort
    top_genres = {}
    sorted_genres.each do |genre| # Find the genres associated with that score
      genre_score = @genres[genre]
      if (top_scores.include?(genre_score)) then # Check if it is a top score
        top_genres[genre] = genre_score
        top_scores.delete_at(top_scores.index(genre_score)) # Remove that score
      end
    end
    return top_genres
  end
 
  def print_genres
    genres = top_genres
    if (genres.size == 0) then # Check if there were any matches
      puts "No matching genres"
    else
      top_genres.each do |genre, score|
        puts genre + ", " + score.to_i.to_s
      end
    end
  end

end

####################################
# Calculating genres for each book #
####################################

# List of all the books
book_list = {}

# For each book, search the entire description for instances of each keyword in
# the CSV file provided and then calculate the score for that particular genre.
# If the no keywords of a genre are present, do not give it a score.
books_hash.each do |book|
  title = book["title"] # Extract title and create book
  description = book["description"] # Extract description
  new_book = Book.new(title, description)
  genres = {}
  # Scan the description for instances of each keyword and store the instances,
  # value for that keyword, and the number of unique keywords.
  genre_values.each do |row|
    genre = row[0]
    keyword = row[1]
    value = row[2].to_i
    instances = description.scan( /#{keyword}/ ).size 
    if (instances > 0) then
      if (genres.has_key?(genre)) then
        genres[genre][0] = genres[genre][0] + instances
        genres[genre][1] = genres[genre][1] + value
        genres[genre][2] = genres[genre][2] + 1
      else
        genres[genre] = [instances, value, 1]
      end
    end
  end
  # Add all of the found genres to the book stored as floats
  genres.each do |genre, values|
    score = values[0] * Float(values[1] / values[2])
    new_book.add_genre(genre, score)
  end
  # Add this book to the book list
  book_list[title] = new_book
end

################################################
# Print out each book and its respective score #
################################################

# Sort the books so they are displayed in alphabetical order
sorted_titles = book_list.keys.sort!
sorted_titles.each do |book|
  puts book # Book title
  book_list[book].print_genres # The top 3 genres
  puts
end
