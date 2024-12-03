#!/usr/bin/env ruby
# frozen_string_literal: true

total =
  File
  .open('../input/day03')
  .read()
  .scan(/mul\((\d+),(\d+)\)/)
  .map { |pair| pair.map(&:to_i) }
  .map { |pair| pair[0] * pair[1] }
  .sum
puts total
