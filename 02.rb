require 'set'

data = File.read("data/02.txt").lines.map(&:strip)
LETTERS = data.flat_map(&:chars).sort.uniq

# Part 1
def part1(data)
  twos = 0
  threes = 0
  data.each do |line|
    counts = line.chars.group_by(&:itself).map(&:last).map(&:count)
    twos += 1 if counts.include?(2)
    threes += 1 if counts.include?(3)
  end
  twos * threes
end

p part1(data)

# Part 2
def part2(data)
  set = Set.new

  data.each do |line|
    (0...line.length).each do |i|
      modified = line.dup
      modified[i] = '_'
      if set.include?(modified)
        return modified.tr('_', '')
      end
      set.add(modified)
    end
  end
end

puts part2(data)

