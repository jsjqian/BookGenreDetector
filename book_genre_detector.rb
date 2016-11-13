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
  puts ARGV[0] + " is not a JSON file."
  exit
end

# Second argument must be a CSV file

if (!(/.csv/.match(ARGV[1]))) then
  puts ARGV[1] + " is not a CSV file."
  exit
end

#######################
# Reading input files #
#######################

# Reading JSON for books

books = File.read(ARGV[0])
book_hash = JSON.parse(books)

# Reading CSV for genres

genres = CSV.read(ARGV[1])

class Book
 
  @title
  @genres

  def initialize(title)
    @title = title
    @genres = {}
  end

  def add_genre(genre, score)
    @genres[genre] = score
  end

  def self.top_genres
    scores = @genres.values
    scores.sort!
    top_scores = scores.first(3)
    sorted_genres = @genres.keys.sort
    top_genres = {}
    sorted_genres.each do |genre|
      genre_score = @genres[genre]
      if (top_scores.include?(genre_score)) then
        top_genre[genre] = genre_score
        top_scores.delete_at(top_scores.index(genre_score))
      end
    end
    return top_genres
  end

  def print_genres
    top_genres = self.class.top_genres
    top_genres.each do |genre, score|
      puts genre + ", " + score
    end
  end

end

####################################
# Calculating genres for each book #
####################################

scores = {}

book_hash.each do |book, description|
  
end





