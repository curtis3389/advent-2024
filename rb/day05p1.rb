#!/usr/bin/env ruby
# frozen_string_literal: true

def effective_rules(rules, update)
  rules.select {|rule| update.any? {|page| page == rule[0]} && update.any? {|page| page == rule[1]}}
end

def in_order?(rules, update)
  effective_rules(rules, update).all? do |rule|
    update.index(rule[0]) < update.index(rule[1])
  end
end

chunks = File
  .open('../input/day05')
  .readlines
  .map(&:strip)
  .slice_when { |c, n| n.empty? }

rules = chunks.next
updates = chunks.next

rules = rules.map {|line| line.split('|').map(&:to_i)}
updates = updates.map {|line| line.split(',').map(&:to_i)}.select {|update| update.count != 0}

total =
  updates
  .select {|update| in_order?(rules, update)}
  .map {|update| update[(update.count / 2)]}
  .sum
p total
