#!/usr/bin/env ruby
# frozen_string_literal: true

class WordSearch
  def initialize(lines)
    @lines = lines
  end

  def xmas_count()
    height = @lines.count
    width = @lines[0].length
    (1...height-1).map do |r|
      (1...width-1).map do |c|
        if xmas?(r, c)
          1
        else
          0
        end
      end.sum
    end.sum
  end

  private def xmas?(r, c)
    @lines[r][c] == 'A' && ((@lines[r-1][c-1] == 'M' && @lines[r+1][c+1] == 'S') || (@lines[r-1][c-1] == 'S' && @lines[r+1][c+1] == 'M')) && ((@lines[r+1][c-1] == 'M' && @lines[r-1][c+1] == 'S') || (@lines[r+1][c-1] == 'S' && @lines[r-1][c+1] == 'M'))
  end
end

text = File.open('../input/day04').readlines
word_search = WordSearch.new text
puts word_search.xmas_count
