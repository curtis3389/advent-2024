#!/usr/bin/env ruby
# frozen_string_literal: true

def get_diffs(report)
  diffs = []
  report.take(report.count - 1).each_index do |index|
    diffs << (report[index] - report[index + 1])
  end
  diffs
end

def old_safe?(report)
  diffs = get_diffs report
  (diffs.all?(&:positive?) || diffs.all?(&:negative?)) && diffs.all? { |d| d.abs >= 1 && d.abs <= 3 }
end

def safe?(report)
  old_safe?(report) || (0...report.count).any? do |index|
    copy = report.clone
    copy.delete_at index
    old_safe? copy
  end
end

reports =
  File
  .open('../input/day02')
  .map(&:strip)
  .reject(&:empty?)
  .map { |line| line.split(/\s+/).map(&:to_i) }

puts reports.select(&method(:safe?)).count
