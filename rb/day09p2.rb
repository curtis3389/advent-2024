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
    Block.new(type, id, length)
  end

to_move = data.select { |block| block.type == :file }.reverse
to_move.each do |block|
  index = data.index(block)
  free, free_index = data.each.lazy.with_index.select { |f, _i| f.type == :free && f.length >= block.length }.first
  if free && free_index < index
    data[free_index] = block
    data[index] = Block.new(:free, nil, block.length)
    data.insert(free_index+1, Block.new(:free, nil, free.length - block.length)) if free.length > block.length
  end
end
data = data
.flat_map {|block| (0...block.length).map {Block.new(block.type, block.id, 1)}}
#p data.map {|block| block.type == :free ? '.' : block.id.to_s }.join
total =
data
.map.with_index do |block, index|
  if block.type == :free
    0
  else
    block.id * index
  end
end.sum
puts total
