#!/usr/bin/env ruby
# frozen_string_literal: true

class Simulation
  attr_reader :visited

  def initialize(grid)
    @heading = :north
    @location = grid.each_with_index.map do |row, y|
      parts = row.each_with_index.find { |cell, x| cell == '^' }
      if parts
        [y, parts[1]]
      else
        nil
      end
    end.compact.first
    @visited = [@location]
    @grid = grid.map {|row| row.map {|cell| if cell == '^' then '.' else cell end}}
  end

  private def next_location
    case
    when @heading == :north
      [@location[0]-1, @location[1]]
    when @heading == :south
      [@location[0]+1, @location[1]]
    when @heading == :east
      [@location[0], @location[1]+1]
    when @heading == :west
      [@location[0], @location[1]-1]
    end
  end

  private def next_heading
    case
    when @heading == :north
      :east
    when @heading == :south
      :west
    when @heading == :east
      :south
    when @heading == :west
      :north
    end
  end

  private def valid?(location)
    location[0] >= 0 && location[0] < @grid.length && location[1] >= 0 && location[1] < @grid[0].length
  end

  private def blocked?(location)
    @grid[location[0]][location[1]] == '#'
  end

  private def move
    next_loc = next_location
    if valid?(next_loc) && blocked?(next_loc)
      @heading = next_heading
      next_loc = next_location
    end
    @location = next_loc
    @visited << @location
  end

  def run
    while valid?(@location)
      move
    end
    @visited = @visited.select {|loc| valid? loc}
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

