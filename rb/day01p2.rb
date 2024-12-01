#!/usr/bin/ruby
lists = File.open('../input/day01').map(&:strip).reject(&:empty?).map do |line|
  parts = line.split /\s+/
  parts.map(&:to_i)
end.reduce([[], []]) { |lists, parts|
  lists[0] << parts[0]
  lists[1] << parts[1]
  lists
}
counts = Hash.new(0)
lists[0].each do |n|
  counts[n] = lists[1].select do |o|
    o == n
  end.count
end
total = 0
counts.each do |pair|
  total += pair[0] * pair[1]
end
puts total
