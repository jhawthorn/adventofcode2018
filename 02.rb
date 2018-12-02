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
def _part2(data)
  data = Set.new(data)

  data.each do |line|
    0.upto(line.length) do |i|
      changed = line.dup
      LETTERS.each do |new_char|
        changed[i] = new_char
        next if changed == line
        return [line, changed] if data.include?(changed)
      end
    end
  end
end

def part2(data)
  a, b = _part2(data)
  a.chars.zip(b.chars).select{|x,y| x == y }.map(&:first).join
end

puts part2(data)

