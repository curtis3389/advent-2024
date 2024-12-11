#!/usr/bin/env ruby
# frozen_string_literal: true

class TopographicMap
  def initialize(elevations)
    @elevations = elevations
  end

  def all_paths
    trailheads = @elevations.flat_map.with_index {|row, r| row.map.with_index {|elevation, c| elevation == 0 ? [r, c] : nil}.compact}
    trailheads.flat_map {|trailhead| find_paths(trailhead)}
  end

#  private

  def find_paths(trailhead)
    elevation = @elevations[trailhead[0]][trailhead[1]]

    if elevation == 9
      [[trailhead]]
    else
      neighbors = neighbors trailhead
      neighbors.flat_map {|neighbor| find_paths(neighbor).select {|path| path != []}.map {|path| path.prepend trailhead}}
    end
  end

  def neighbors(location)
    row, col = location
    elevation = @elevations[row][col]
    [[row-1, col], [row+1, col], [row, col-1], [row, col+1]]
      .select {|loc| valid? loc}
      .select {|loc| @elevations[loc[0]][loc[1]] == elevation + 1}
  end

  def valid?(location)
    location[0] >= 0 && location[0] < @elevations.length &&
      location[1] >= 0 && location[1] < @elevations[0].length
  end
end

elevations =
  File
    .open('../input/day10-sample')
    .readlines
    .map(&:strip)
    .map(&:chars)
    .map {|line| line.map(&:to_i)}
map = TopographicMap.new elevations
paths = map.all_paths
trailheads = paths.map {|path| path.first}.uniq
puts trailheads.map {|trailhead| paths.select {|path| path[0] == trailhead}.count}.sum
