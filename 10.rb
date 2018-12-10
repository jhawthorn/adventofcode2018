require 'set'
require 'time'

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

def calculate(input)
  i = 0
  last = nil
  last_size = Float::INFINITY

  loop do
    data = tick(input, i)
    data_size = size(data)
    break if data_size > last_size
    i += 1
    last, last_size = data, data_size
  end

  draw(last)
  p i
end


data = parse(File.read("data/10_test.txt"))
p calculate(data)

data = parse(File.read("data/10.txt"))
p calculate(data)
