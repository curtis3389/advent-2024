#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents a do/don't/mul instruction.
class Instruction
  attr_reader :type, :data

  def initialize(type, *data)
    @type = type
    @data = data.map(&:to_i)
  end

  def self.parse(text)
    text
      .scan(/(do|don't|mul)\(((\d+),(\d+))?\)/)
      .map do |match|
      if match[0] == 'mul'
        Instruction.new(match[0], match[2], match[3])
      else
        Instruction.new(match[0])
      end
    end
  end
end

text = File.read '../input/day03'
instructions = Instruction.parse text
do_instruction = true
total = 0

instructions.each do |instruction|
  if instruction.type == 'mul' && do_instruction
    total += instruction.data[0] * instruction.data[1]
  elsif instruction.type == 'do'
    do_instruction = true
  elsif instruction.type == 'don\'t'
    do_instruction = false
  end
end

puts total
