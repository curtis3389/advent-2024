#!/usr/bin/env ruby
# frozen_string_literal: true

lists =
  File
  .open('../input/day01')
  .map(&:strip)
  .reject(&:empty?)
  .map { |line| line.split(/\s+/).map(&:to_i) }
  .each_with_object([[], []]) do |parts, acc|
    acc[0] << parts[0]
    acc[1] << parts[1]
  end

lists[0].sort!
lists[1].sort!

total =
  (0...lists[0].count)
  .map { |i| (lists[0][i] - lists[1][i]).abs }
  .sum
puts total
