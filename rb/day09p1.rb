#!/usr/bin/env ruby
# frozen_string_literal: true

class Block
  attr_reader :type, :id, :length

  def initialize(type, id, length)
    @type = type
    @id = id
    @length = length
  end
end

data = File
  .read('../input/day09')
  .strip
  .chars
  .map(&:to_i)
  .each
  .with_index
  .flat_map do |length, index|
    if index.odd?
      type = :free
      id = nil
    else
      type = :file
      id = index / 2
    end
    (0...length).map { Block.new(type, id, 1) }
  end

left = 0
right = data.length - 1

while left < right
  left += 1 while data[left].type != :free && left < right
  right -= 1 while data[right].type == :free && left < right
  break unless left < right && data[left].type == :free && data[right].type != :free

  data[left], data[right] = data[right], data[left]
end

total = data.map.with_index do |block, index|
  if block.type == :free
    0
  else
    block.id * index
  end
end.sum
puts total
