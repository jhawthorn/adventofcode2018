require 'set'
require 'time'

def calculate(data)
  events =
    data.map do |line|
      line =~ /\A\[(\d+-\d+-\d+ \d+:\d+)\] (.*)\z/ || raise
      [Time.parse($1), $2]
    end

  events.sort_by!(&:first)

  guards = Hash.new do |h, k|
    h[k] = Hash.new(0)
  end

  current_guard = nil
  sleeping = false

  events.each do |(time, event)|
    if event == "falls asleep"
      raise if time.hour != 0
      sleeping = time.min
    elsif event == "wakes up"
      minutes_slept = time.min - sleeping
      sleeping.upto(time.min - 1) do |t|
        guards[current_guard][t] += 1
      end
      raise if time.hour != 0
      #p minutes_slept
      sleeping = false
    elsif event =~ /Guard #(\d+) begins shift/
      raise if sleeping
      current_guard = $1.to_i
      sleeping = false
    else
      raise
    end
  end

  guards
end

def part1(data)
  guards = calculate(data)
  guard_id, minutes = guards.max_by {|_,m| m.values.sum }
  minute, _ = minutes.max_by{|_,m| m }
  guard_id * minute
end

def part2(data)
  guards = calculate(data)
  guard_id, minutes = guards.max_by {|_,m| m.values.max }
  minute, _ = minutes.max_by{|_,m| m }
  guard_id * minute
end

data = File.read("data/04_test.txt").lines.map(&:strip)
raise unless part1(data) == 240
raise unless part2(data) == 4455

data = File.read("data/04.txt").lines.map(&:strip)
p part1(data)
p part2(data)
