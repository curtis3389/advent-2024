#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents a location on a Map.
class Location
  attr_reader :type

  def initialize(col)
    @type =
      case col
      when '.'
        :open
      when '^'
        :start
      when '#'
        :blocked
      end
    @visited = {
      north: false,
      south: false,
      east: false,
      west: false
    }
    @temporarily_blocked = false
  end

  def block
    @temporarily_blocked = true
  end

  def blocked?
    @type == :blocked || @temporarily_blocked
  end

  def reset
    @visited = {
      north: false,
      south: false,
      east: false,
      west: false
    }
    @temporarily_blocked = false
  end

  def visit(heading)
    @visited[heading] = true
  end

  def visited?(heading)
    @visited[heading]
  end
end

# Represents a map/simulation of a guard patrolling a warehouse.
class Map
  def initialize(grid)
    @grid = grid.map { |row| row.map { |cell| Location.new(cell) } }
    @height = @grid.length
    @width = @grid[0].length
    @start = @grid.each_with_index.map do |row, y|
      parts = row.each_with_index.find { |cell, _x| cell.type == :start }
      [y, parts[1]] if parts
    end.compact.first
    @visited = []
  end

  def visited
    @visited = []
    heading = :north
    location = @start.clone
    while valid?(location) && !visited?(location, heading)
      mark location, heading
      @visited << location

      next_loc = next_location(location, heading)
      while valid?(next_loc) && blocked?(next_loc)
        heading = next_heading(heading)
        next_loc = next_location(location, heading)
      end
      location = next_loc
    end
    reset
    @visited.select { |loc| valid?(loc) && loc != @start }.uniq
  end

  def reset
    @grid.each do |row|
      row.each(&:reset)
    end
  end

  def visited?(location, heading)
    return false unless valid?(location)

    cell = @grid[location[0]][location[1]]
    cell.visited?(heading)
  end

  def loops?(obstruction)
    @grid[obstruction[0]][obstruction[1]].block
    heading = :north
    location = @start.clone
    begin
      while valid?(location)
        mark location, heading

        next_loc = next_location(location, heading)
        while valid?(next_loc) && blocked?(next_loc)
          heading = next_heading(heading)
          next_loc = next_location(location, heading)
        end
        location = next_loc

        return true if visited?(location, heading)
      end

      false
    ensure
      reset
    end
  end

  private

  def mark(loc, heading)
    @grid[loc[0]][loc[1]].visit(heading)
  end

  def valid?(loc)
    loc[0] >= 0 && loc[0] < @height && loc[1] >= 0 && loc[1] < @width
  end

  def blocked?(location)
    @grid[location[0]][location[1]].blocked?
  end

  def next_location(location, heading)
    case heading
    when :north
      [location[0] - 1, location[1]]
    when :south
      [location[0] + 1, location[1]]
    when :east
      [location[0], location[1] + 1]
    when :west
      [location[0], location[1] - 1]
    end
  end

  NEXT_HEADING = {
    north: :east,
    east: :south,
    south: :west,
    west: :north
  }.freeze

  def next_heading(heading)
    NEXT_HEADING[heading]
  end
end

grid =
  File
  .open('../input/day06')
  .readlines
  .map(&:strip)
  .map(&:chars)

m = Map.new(grid)
puts m.visited.lazy.map { |l| m.loops?(l) ? 1 : 0 }.sum
