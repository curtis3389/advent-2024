#!/usr/bin/ruby
lists = File.open('../input/day01').map(&:strip).reject(&:empty?).map do |line|
  parts = line.split /\s+/
  parts.map(&:to_i)
end.reduce([[], []]) { |lists, parts|
  lists[0] << parts[0]
  lists[1] << parts[1]
  lists
}
lists[0].sort!
lists[1].sort!
total = 0
for i in 0...lists[0].count do
  total += (lists[0][i] - lists[1][i]).abs
end
puts total
