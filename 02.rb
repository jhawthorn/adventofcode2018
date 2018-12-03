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
  data.each do |a|
    data.each do |b|
      unmatch = a.chars.zip(b.chars).map{|x,y| x != y }
      next unless unmatch.one?
      chars = a.chars
      chars.delete_at(unmatch.index(true))
      return chars.join
    end
  end
end

puts part2(data)

