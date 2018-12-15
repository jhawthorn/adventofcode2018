class Grid
  attr_reader :serial
  attr_reader :sums

  def initialize(serial)
    @serial = serial

    @sums = Array.new(301) { Array.new(301) { 0 } }

    1.upto(300) do |y|
      1.upto(300) do |x|
        @sums[y][x] =
          cell(x,y) +
          @sums[y - 1][x] +
          @sums[y][x - 1] -
          @sums[y - 1][x - 1];
      end
    end
  end

  def cubesum(x,y,s)
    x -= 1
    y -= 1
    @sums[y][x] -
      @sums[y + s][x] -
      @sums[y][x + s] +
      @sums[y + s][x + s];
  end

  def part1()
    s = 3
    1.upto(301-s).map do |y|
      1.upto(301-s).map do |x|
        [cubesum(x,y,s), [x,y]]
      end.max_by(&:first)
    end.max_by(&:first).last
  end

  def part2()
    1.upto(298).map do |y|
      1.upto(298).map do |x|
        maxs = [301-x, 301-y].min
        3.upto(maxs).map do |s|
          [cubesum(x,y,s), [x,y,s]]
        end.max_by(&:first)
      end.max_by(&:first)
    end.max_by(&:first).last
  end

  def cell(x,y)
    rack_id = (x + 10)
    level = (rack_id * y + serial) * rack_id
    (level / 100 % 10) - 5
  end
end

raise unless Grid.new(8).cell(3,5) == 4

raise unless Grid.new(57).cell(122,79) == -5
raise unless Grid.new(39).cell(217,196) == 0
raise unless Grid.new(71).cell(101,153) == 4

raise unless Grid.new(18).part1 == [33, 45]
raise unless Grid.new(18).cubesum(33, 45, 3) == 29
raise unless Grid.new(42).part1 == [21, 61]
raise unless Grid.new(42).cubesum(21, 61, 3) == 30

puts Grid.new(1788).part1.join(",")

raise unless Grid.new(18).part2 == [90, 269, 16]
raise unless Grid.new(42).part2 == [232, 251, 12]

puts Grid.new(1788).part2.join(",")
