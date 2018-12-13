require 'time'
require 'set'

class Track
  attr_reader :lines, :trains

  DIRECTIONS = %w[< ^ > v]
  UNDER_TRAIN = {
    "<" => "-",
    ">" => "-",
    "^" => "|",
    "v" => "|",
  }

  DIRECTIONS_V = {
    "<" => [-1,0],
    "^" => [0,-1],
    ">" => [1,0],
    "v" => [0,1],
  }

  class Train < Struct.new(:track, :x, :y, :direction, :turns, :crashed)
    def step
      return if crashed

      dx, dy = DIRECTIONS_V[direction]
      self.x += dx
      self.y += dy

      case under
      when "/"
        self.direction =
          case self.direction
          when "<" then "v"
          when ">" then "^"
          when "^" then ">"
          when "v" then "<"
          end
      when "\\"
        self.direction =
          case self.direction
          when "<" then "^"
          when ">" then "v"
          when "^" then "<"
          when "v" then ">"
          end
      when "+"
        if self.turns % 3 == 0
          left
        elsif self.turns % 3 == 2
          right
        end

        self.turns += 1
      end
    end

    def under
      track.lines[y][x]
    end

    def left
      self.direction = DIRECTIONS[
        (DIRECTIONS.index(direction) + 3) % 4
      ]
    end

    def right
      self.direction = DIRECTIONS[
        (DIRECTIONS.index(direction) + 1) % 4
      ]
    end

    def to_s
      direction
    end
  end

  def initialize(lines)
    @lines = lines
    @trains = []

    lines.each.with_index do |line, y|
      line.chars.each.with_index do |c, x|
        if DIRECTIONS.include?(c)
          @trains << Train.new(
            self,
            x,
            y,
            c,
            0
          )
          line[x] = UNDER_TRAIN[c]
        end
      end
    end
  end

  def to_s
    lines = @lines.map(&:dup)
    trains.each do |train|
      lines[train.y][train.x] = train.to_s
    end
    crashes.each do |(x,y)|
      lines[y][x] = "X"
    end
    lines.join("\n")
  end

  def inspect
    to_s
  end

  def step
    trains.sort_by!{|t| [t.y, t.x] }
    trains.each do |train|
      next if train.crashed

      train.step

      if trains.reject(&:crashed) == [train]
        return [train.x, train.y]
      end

      crashes.each do |position, ts|
        ts.each do |t|
          t.crashed = true
        end
      end
    end
    nil
  end

  def crashes
    trains.reject(&:crashed).group_by{|t| [t.x, t.y] }.select{ |_, p| p.count > 1 }
  end
end

def parse(data)
  Track.new data.lines.map(&:chop)
end

def calculate(track)
  loop do
    crash = track.step
    return crash if crash
  end
end

track = parse(File.read("data/13_test2.txt"))
p calculate(track)

track = parse(File.read("data/13.txt"))
p calculate(track)
