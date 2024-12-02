#!/usr/bin/env ruby
reports =
  File
    .open('../input/day02')
    .map(&:strip)
    .reject(&:empty?)
    .map do |line|
      line.split(/\s+/).map(&:to_i)
    end

tmp = reports.map do |report|
  diffs = []
  report.take(report.count - 1).each_index do |index|
    diffs << report[index] - report[index+1]
  end
  diffs
end
tmp = tmp.select do |diffs|
  (diffs.all? { |d| d > 0 } || diffs.all? { |d| d < 0 }) && diffs.all? { |d| d.abs >= 1 && d.abs <= 3 }
end
puts tmp.count
