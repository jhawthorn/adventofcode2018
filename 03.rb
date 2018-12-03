require 'set'

data = File.read("data/03.txt").lines.map(&:strip)

def calculate(data)
  grid = Hash.new do |h, k|
    h[k] = []
  end

  set = Set.new((1..1373).to_a)

  data.each do |line|
    line =~ /\A#(\d+) @ (\d+),(\d+): (\d+)x(\d+)\z/ || raise

    n = $1.to_i
    bx = $2.to_i
    by = $3.to_i
    w = $4.to_i
    h = $5.to_i

    by.upto(by + h - 1) do |y|
      bx.upto(bx + w - 1) do |x|
        grid[[x,y]] << n
      end
    end
  end

  overlaps = grid.values.select{|v| v.count >= 2}

  p overlaps.count

  p (set - overlaps.flatten).first
end

calculate(data)
