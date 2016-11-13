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
books_hash = JSON.parse(books)

# Reading CSV for genres

genre_values = CSV.read(ARGV[1])
genre_values.shift

class Book
 
  @title
  @genres = {}

  def initialize(title)
    @title = title
    @genres = {}
  end

  def add_genre(genre, score)
    @genres[genre] = score
  end

  def print_genres
    scores = @genres.values
    scores.sort!
    top_scores = scores.first(3)
    sorted_genres = @genres.keys.sort
    top_genres = {}
    sorted_genres.each do |genre|
      genre_score = @genres[genre]
      if (top_scores.include?(genre_score)) then
        top_genres[genre] = genre_score
        top_scores.delete_at(top_scores.index(genre_score))
      end
    end
    top_genres.each do |genre, score|
      puts genre + ", " + score.to_i.to_s
    end
  end

end

####################################
# Calculating genres for each book #
####################################

book_list = {}

books_hash.each do |book|
  title = book["title"]
  new_book = Book.new(title)
  description = book["description"]
  genres = {}
  genre_values.each do |row|
    genre = row[0]
    keyword = row[1].strip
    value = row[2].strip.to_i
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
  genres.each do |genre, values|
    score = values[0] * Float(values[1] / values[2])
    new_book.add_genre(genre, score)
  end
  book_list[title] = new_book
end

################################################
# Print out each book and its respective score #
################################################

sorted_titles = book_list.keys.sort!
sorted_titles.each do |book|
  puts book
  book_list[book].print_genres
  puts
end


