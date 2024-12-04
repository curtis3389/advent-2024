#!/usr/bin/env ruby
# frozen_string_literal: true

class WordSearch
  def initialize(lines)
    @lines = lines
  end

  def xmas_count()
    forward = forward_count
    backward = backward_count
    down = down_count
    up = up_count
    diag_downlr = diag_downlr_count
    diag_uplr = diag_uplr_count
    diag_downrl = diag_downrl_count
    diag_uprl = diag_uprl_count

    forward + backward + down + up + diag_downlr + diag_uplr + diag_downrl + diag_uprl
  end

  private def forward_count()
    @lines.map { |line| line.scan('XMAS').count }.sum
  end

  private def backward_count()
    @lines.map { |line| line.scan('SAMX').count }.sum
  end

  private def down_count()
    columns.map { |line| line.scan('XMAS').count }.sum
  end

  private def up_count()
    columns.map { |line| line.scan('SAMX').count }.sum
  end

  private def diag_downlr_count()
    height = @lines.count
    width = @lines[0].length
    (0...height-3).map do |r|
      (0...width-3).map do |c|
        if @lines[r][c] == 'X' && @lines[r+1][c+1] == 'M' && @lines[r+2][c+2] == 'A' && @lines[r+3][c+3] == 'S'
          1
        else
          0
        end
      end.sum
    end.sum
  end

  private def diag_uplr_count()
    height = @lines.count
    width = @lines[0].length
    (3...height).map do |r|
      (0...width-3).map do |c|
        if @lines[r][c] == 'X' && @lines[r-1][c+1] == 'M' && @lines[r-2][c+2] == 'A' && @lines[r-3][c+3] == 'S'
          1
        else
          0
        end
      end.sum
    end.sum
  end

  private def diag_downrl_count()
    height = @lines.count
    width = @lines[0].length
    (0...height-3).map do |r|
      (3...width).map do |c|
        if @lines[r][c] == 'X' && @lines[r+1][c-1] == 'M' && @lines[r+2][c-2] == 'A' && @lines[r+3][c-3] == 'S'
          1
        else
          0
        end
      end.sum
    end.sum
  end

  private def diag_uprl_count()
    height = @lines.count
    width = @lines[0].length
    (3...height).map do |r|
      (3...width).map do |c|
        if @lines[r][c] == 'X' && @lines[r-1][c-1] == 'M' && @lines[r-2][c-2] == 'A' && @lines[r-3][c-3] == 'S'
          1
        else
          0
        end
      end.sum
    end.sum
  end

  def columns()
    (0...@lines[0].length-1).map { |index| @lines.map { |line| line[index] }.join }
  end
end

text = File.open('../input/day04').readlines
word_search = WordSearch.new text
puts word_search.xmas_count
