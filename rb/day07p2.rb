#!/usr/bin/env ruby
# frozen_string_literal: true

class Equation
  attr_reader :result, :numbers
  def initialize(line)
    @result, *@numbers = line.split(/(\s|:)+/).map(&:strip).select {|s| !s.empty?}.map(&:to_i)
  end

  def solvable?
    combos = combinations(@numbers)
    combos.any? {|result| result == @result}
  end

  private def combinations(numbers)
    if numbers.length == 2
      a,b = numbers
      result = [a+b, a*b, concat(a,b)]
      result
    else
      *rest, a = numbers
      combos = combinations(rest)
      result = combos.map {|val| a + val} + combos.map {|val| a * val} + combos.map {|val| concat(val, a)}
      result
    end
  end

  private def concat(a, b)
    "#{a}#{b}".to_i
  end
end

total =
  File
    .open('../input/day07')
    .readlines
    .map(&:strip)
    .map {|line| Equation.new(line)}
    .select {|equation| equation.solvable?}
    .map {|equation| equation.result}
    .sum
puts total
