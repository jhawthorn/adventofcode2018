require 'set'

def parse(data)
  data.lines.map{|l| l.split(/, */).map(&:strip).map(&:to_i) }
end

def size(data)
  xs = data.map(&:first)
  (xs.max - xs.min).abs
end

def draw(points)
  points = Set.new(points)

  minx = points.map(&:first).min
  miny = points.map(&:last).min
  maxx = points.map(&:first).max
  maxy = points.map(&:last).max

  miny.upto(maxy) do |y|
    minx.upto(maxx) do |x|
      print points.include?([x,y]) ? "#" : '.'
    end
    puts
  end
  nil
end

def tick(data, t)
  data.map do |(x,y,vx,vy)|
    [x + vx * t, y + vy * t]
  end
end

class Range
  def tsearch
    left, right = self.begin, self.end

    loop do
      if right - left <= 2
        return (left + right)/2
      end

      leftThird = (2*left + right)/3
      rightThird = (left + 2*right)/3

      if yield(leftThird) < yield(rightThird)
        left = leftThird
      else
        right = rightThird
      end
    end
  end
end

def calculate(input)
  i = (0...100_000).tsearch { |i| -size(tick(input, i)) }
  p i
  draw(tick(input, i))
end


data = parse(File.read("data/10_test.txt"))
calculate(data)

data = parse(File.read("data/10.txt"))
calculate(data)
