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
  puts "Missing arguments"
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

