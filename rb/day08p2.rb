#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents an antinode on a Map.
class Antinode
  attr_reader :location, :frequency

  def initialize(location, frequency)
    @location = location
    @frequency = frequency
  end
end

# Represents a map of antennas.
class Map
  def initialize(grid)
    @grid = grid
    @height = grid.length
    @width = grid[0].length
    @cache = {}
  end

  def antinodes
    locations
      .flat_map { |location| find_antinodes(location) }
      .compact
  end

  private

  def locations
    @grid
      .each_index
      .flat_map { |row| @grid[row].each_index.map { |col| [row, col] } }
  end

  def find_antinodes(location)
    max_dist = @height + @width
    distances = (0..max_dist).map { |d| frequencies_at(location, d) }
    (0..max_dist).flat_map do |distance|
      current = distances[distance]
      possibles = distances[(distance + 1)..].flat_map { |a| a }
      antinode_frequencies =
        current
        .select do |pair|
          possibles.any? do |other|
            other[1] == pair[1] && (
              (slope(location, pair[0]) - slope(location, other[0])).abs < 1e-9 ||
              slope(location, pair[0]).nan?)
          end
        end
        .map { |pair| pair[1] }
        .uniq
      antinode_frequencies.map { |freq| Antinode.new(location, freq) }
    end
  end

  def slope(loc_a, loc_b)
    (loc_b[0] - loc_a[0]) / ((loc_b[1] - loc_a[1]) * 1.0)
  end

  def valid?(loc)
    loc[0] >= 0 && loc[0] < @height && loc[1] >= 0 && loc[1] < @width
  end

  def frequencies_at(location, distance)
    distant_locations(location, distance)
      .select { |loc| valid? loc }
      .map { |loc| [loc, @grid[loc[0]][loc[1]]] }
      .reject { |pair| pair[1] == '.' }
  end

  def distant_locations(location, distance)
    diffs(distance).map { |d| [location[0] + d[0], location[1] + d[1]] }
  end

  def diffs(distance)
    cached = @cache[distance]
    if cached
      cached
    else
      result = (-distance..+distance).flat_map do |r|
        (-distance..+distance)
          .map { |c| r.abs + c.abs == distance ? [r, c] : nil }
          .compact
      end
      @cache[distance] = result
      result
    end
  end
end

grid =
  File
  .open('../input/day08')
  .readlines
  .map(&:strip)
  .map(&:chars)
map = Map.new grid
puts map.antinodes.map(&:location).uniq.count
