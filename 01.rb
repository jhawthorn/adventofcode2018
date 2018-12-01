require 'set'

data = File.read("data/01.txt").lines.map(&:strip).map(&:to_i)

# Part 1
p data.sum

# Part 2
def part2(data)
  seen = Set.new
  acc = 0
  loop do
    data.each do |value|
      seen.add(acc)
      acc += value
      if seen.include?(acc)
        return acc
      end
    end
  end
end
p part2(data)
