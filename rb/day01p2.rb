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

counts = Hash.new(0)
lists[0].each do |n|
  counts[n] = lists[1].select { |o| o == n }.count
end

total =
  counts
  .map { |pair| pair[0] * pair[1] }
  .sum
puts total
