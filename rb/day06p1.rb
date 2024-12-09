#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents a simulation of a guard patrolling a warehouse.
class Simulation
  attr_reader :visited

  def initialize(grid)
    @heading = :north
    @location = grid.each_with_index.map do |row, y|
      parts = row.each_with_index.find { |cell, _x| cell == '^' }
      [y, parts[1]] if parts
    end.compact.first
    @visited = [@location]
    @grid = grid.map { |row| row.map { |cell| cell == '^' ? '.' : cell } }
  end

  def run
    move while valid?(@location)
    @visited = @visited.select { |loc| valid? loc }
  end

  private

  def next_location
    case @heading
    when :north
      [@location[0] - 1, @location[1]]
    when :south
      [@location[0] + 1, @location[1]]
    when :east
      [@location[0], @location[1] + 1]
    when :west
      [@location[0], @location[1] - 1]
    end
  end

  NEXT_HEADING = {
    north: :east,
    east: :south,
    south: :west,
    west: :north
  }.freeze

  def next_heading
    NEXT_HEADING[@heading]
  end

  def valid?(location)
    location[0] >= 0 && location[0] < @grid.length &&
      location[1] >= 0 && location[1] < @grid[0].length
  end

  def blocked?(location)
    @grid[location[0]][location[1]] == '#'
  end

  def move
    next_loc = next_location
    if valid?(next_loc) && blocked?(next_loc)
      @heading = next_heading
      next_loc = next_location
    end
    @location = next_loc
    @visited << @location
  end
end

grid =
  File
  .open('../input/day06')
  .readlines
  .map(&:strip)
  .map(&:chars)

simulation = Simulation.new(grid)
simulation.run
puts simulation.visited.uniq.count
