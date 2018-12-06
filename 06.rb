require 'set'
require 'time'

def parse(input)
  input.lines.map(&:strip).map{|x| x.split(", ").map(&:to_i) }
end

def calculate(data, maxd)
  delta = 10
  minx = data.map(&:first).min - delta
  miny = data.map(&:last).min - delta
  maxx = data.map(&:first).max + delta
  maxy = data.map(&:last).max + delta

  closest = {}
  set = {}

  i = 0

  miny.upto(maxy) do |y|
    minx.upto(maxx) do |x|
      dists = data.map { |d| (d[0] - x).abs + (d[1] - y).abs }

      if dists.sum < maxd
        i += 1
        set[[x,y]] = true
      end

      dist = dists.min
      points = data.select { |d| (d[0] - x).abs + (d[1] - y).abs == dist }
      closest[[x,y]] = points[0] if points.one?
    end
  end

  #miny.upto(maxy) do |y|
  #  minx.upto(maxx) do |x|
  #    print(set[[x,y]] ? "#" : ".")
  #  end
  #  puts
  #end

  all_points = closest.values

  rejected = Set.new(
    closest.select do |(x, y), _|
      x == minx || x == maxx || y == miny || y == maxy
    end.values.uniq
  )

  all_points = closest.select{ |_, v| !rejected.include?(v) }.values
  [
    all_points.group_by(&:itself).transform_values(&:count).values.max,
    i
  ]
end

data = File.read("data/06_test.txt")
data = parse(data)
raise unless calculate(data, 32) == [17, 16]

data = File.read("data/06.txt")
data = parse(data)
puts calculate(data, 10000)
