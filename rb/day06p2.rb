#!/usr/bin/env ruby
# frozen_string_literal: true

class Location
  attr_reader :type
  
  def initialize(c)
    @type =
      case
      when c == '.'
        :open
      when c == '^'
        :start
      when c == '#'
        :blocked
      end
    @visited = {
      north: false,
      south: false,
      east: false,
      west: false,
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
      west: false,
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

class Map
  def initialize(grid)
    @grid = grid.map {|row| row.map {|cell| Location.new(cell)}}
    @height = @grid.length
    @width = @grid[0].length
    @start = @grid.each_with_index.map do |row, y|
      parts = row.each_with_index.find { |cell, x| cell.type == :start }
      if parts
        [y, parts[1]]
      else
        nil
      end
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
    @visited.select {|loc| valid?(loc) && loc != @start}.uniq
  end

  def reset
    @grid.each do |row|
      row.each do |cell|
        cell.reset
      end
    end
  end

  def visited?(location, heading)
    return false if !valid?(location)
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

        if visited?(location, heading)
          return true
        end
      end

      false
    ensure
      reset
    end
  end

  private def mark(loc, heading)
    @grid[loc[0]][loc[1]].visit(heading)
  end

  private def valid?(loc)
    loc[0] >= 0 && loc[0] < @height && loc[1] >= 0 && loc[1] < @width
  end

  private def blocked?(location)
    @grid[location[0]][location[1]].blocked?
  end

  private def next_location(location, heading)
    case
    when heading == :north
      [location[0]-1, location[1]]
    when heading == :south
      [location[0]+1, location[1]]
    when heading == :east
      [location[0], location[1]+1]
    when heading == :west
      [location[0], location[1]-1]
    end
  end

  private def next_heading(heading)
    case
    when heading == :north
      :east
    when heading == :south
      :west
    when heading == :east
      :south
    when heading == :west
      :north
    end
  end
end
p
grid =
  File
    .open('../input/day06')
    .readlines
    .map(&:strip)
    .map(&:chars)

m = Map.new(grid)
puts m.visited.lazy.map {|l| if m.loops?(l) then 1 else 0 end}.sum
