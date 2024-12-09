#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents a word search for Xs of MAS.
class WordSearch
  def initialize(lines)
    @lines = lines
  end

  def xmas_count
    height = @lines.count
    width = @lines[0].length
    (1...height-1).map do |row|
      (1...width-1).map do |col|
        if xmas?(row, col)
          1
        else
          0
        end
      end.sum
    end.sum
  end

  private

  def xmas?(row, col)
    @lines[row][col] == 'A' &&
      ((@lines[row - 1][col - 1] == 'M' && @lines[row + 1][col + 1] == 'S') ||
       (@lines[row - 1][col - 1] == 'S' && @lines[row + 1][col + 1] == 'M')) &&
      ((@lines[row + 1][col - 1] == 'M' && @lines[row - 1][col + 1] == 'S') ||
       (@lines[row + 1][col - 1] == 'S' && @lines[row - 1][col + 1] == 'M'))
  end
end

text = File.open('../input/day04').readlines
word_search = WordSearch.new text
puts word_search.xmas_count
