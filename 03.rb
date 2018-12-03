require 'set'

data = File.read("data/03.txt").lines.map(&:strip)

def calculate(data)
  grid = Hash.new do |h, k|
    h[k] = []
  end

  data.each do |line|
    line =~ /\A#(\d+) @ (\d+),(\d+): (\d+)x(\d+)\z/ || raise

    n = $0
    bx = $2.to_i
    by = $3.to_i
    w = $4.to_i
    h = $5.to_i

    by.upto(by + h - 1) do |y|
      bx.upto(bx + w - 1) do |x|
        grid[[x,y]] += 1
      end
    end
  end

  grid.values.select{|v| v >= 2}.countt a
end

test = [
"#1 @ 1,3: 4x4",
"#2 @ 3,1: 4x4",
"#3 @ 5,5: 2x2",
]


pp calculate(test)
pp calculate(data)
