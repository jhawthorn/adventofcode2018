require 'set'

data = File.read("data/02.txt").lines.map(&:strip)

def calculate(data)
  twos = 0
  threes = 0
  data.each do |line|
    counts = line.chars.group_by{ |x| x }.map do |c, lines|
      lines.count
    end
    p counts
    twos += 1 if counts.include?(2)
    threes += 1 if counts.include?(3)
  end
  twos * threes
end

# Part 1
p calculate(data)

