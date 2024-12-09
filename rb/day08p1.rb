#!/usr/bin/env ruby
# frozen_string_literal: true

class Antinode
  attr_reader :location, :frequency

  def initialize(location, frequency)
    @location = location
    @frequency = frequency
  end
end

class Map
  def initialize(grid)
    @grid = grid
    @height = grid.length
    @width = grid[0].length
    @cache = {}
  end

  def antinodes
    locations.flat_map {|location| find_antinodes(location)}.compact
  end

  private def locations
    @grid.each_index.flat_map {|row| @grid[row].each_index.map {|col| [row, col]}}
  end

  private def find_antinodes(location)
    max_dist = (([@height, @width].max) / 1.0).ceil
    (1..max_dist).flat_map do |distance|
      closer = frequencies_at(location, distance)
      farther = frequencies_at(location, distance+distance)
      antinode_frequencies = closer.select {|pair| farther.any? {|other| other[1] == pair[1] && (slope(location, pair[0]) - slope(location, other[0])).abs < 1e-9}}.map {|pair| pair[1]}.uniq
      antinode_frequencies.map {|freq| Antinode.new(location, freq)}
    end
  end

  private def slope(a, b)
    (b[0] - a[0])/((b[1] - a[1]) * 1.0)
  end

  private def valid?(loc)
    loc[0] >= 0 && loc[0] < @height && loc[1] >= 0 && loc[1] < @width
  end

  private def frequencies_at(location, distance)
    distant_locations(location, distance)
      .select {|location| valid? location}
      .map {|location| [location, @grid[location[0]][location[1]]]}
      .select {|pair| pair[1] != '.'}
  end

  private def distant_locations(location, distance)
    diffs(distance).map {|d| [location[0] + d[0], location[1] + d[1]]}
  end

  private def diffs(distance)
    cached = @cache[distance]
    if cached
      cached
    else
      row, col = [0,0]
      result = (row-distance..row+distance).flat_map {|r| (col-distance..col+distance).map {|c| if (row-r).abs + (col-c).abs == distance then [r, c] else nil end}.compact}
      @cache[distance] = result
      result
    end
  end

  def test
    p frequencies_at([0,0], 1)
    p frequencies_at([0,0], 2)
    p frequencies_at([0,0], 3)
    p frequencies_at([0,0], 4)
    p frequencies_at([0,0], 5)
    p frequencies_at([0,0], 6)
    p frequencies_at([0,0], 7)
    p frequencies_at([0,0], 8)
  end
end

grid = File.open('../input/day08')
  .readlines
  .map(&:strip)
  .map(&:chars)
map = Map.new grid
antinodes = map.antinodes
grid.map.with_index {|row, r| row.map.with_index {|cell, c| if antinodes.any? {|a| a.location[0] == r && a.location[1] == c} then '#' else cell end}}.each do |row|
  puts row.join
end
puts antinodes.map(&:location).uniq.count
