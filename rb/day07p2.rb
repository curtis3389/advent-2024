#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents an equation missing its operators.
class Equation
  attr_reader :result, :numbers

  def initialize(line)
    parts =
      line
      .split(/(\s|:)+/)
      .map(&:strip)
      .reject(&:empty?)
      .map(&:to_i)
    @result, *@numbers = parts
  end

  def solvable?
    combos = combinations(@numbers)
    combos.any? { |result| result == @result }
  end

  private

  def combinations(numbers)
    if numbers.length == 2
      a, b = numbers
      [a + b, a * b, concat(a, b)]
    else
      *rest, a = numbers
      combos = combinations(rest)

      combos.map { |val| a + val } +
        combos.map { |val| a * val } +
        combos.map { |val| concat(val, a) }
    end
  end

  def concat(left, right)
    "#{left}#{right}".to_i
  end
end

total =
  File
  .open('../input/day07')
  .readlines
  .map(&:strip)
  .map { |line| Equation.new(line) }
  .select(&:solvable?)
  .map(&:result)
  .sum

puts total
