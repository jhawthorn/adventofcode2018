require 'set'
require 'time'
require 'tsort'

def parse(input)
  input.lines.map(&:strip).map(&:split).map(&:reverse)
end

class Thing
  def initialize(data)
    @nodes = data.flatten.uniq.sort
    @data = data

    @deps = Hash.new([].freeze)
    @deps.update data.group_by(&:first).transform_values{|x| Set.new(x.map(&:last).sort.uniq) }
  end

  def done?
    @nodes.empty?
  end

  def next_node
    runnable = @nodes.select { |n| @deps[n].empty? }
    node = runnable.sort.first

    if node
      @nodes.delete(node)
      node
    end
  end

  def next_node!
    node = next_node
    remove(node)
    node
  end

  def remove(node)
    @deps.transform_values{|v| v.delete(node) }
  end
end

def part1(data)
  thing = Thing.new(data)
  s = ""
  s << thing.next_node! until thing.done?
  s
end

def part2(data, n=2, base=0)
  workers = []
  thing = Thing.new(data)

  time = 0
  done = ""

  while true do
    while workers.length < n
      node = thing.next_node
      break unless node
      workers << [
        node,
        base + 1 + node.ord - 'A'.ord
      ]
    end

    break if workers.empty?

    time += 1

    workers.map! do |(i,j)|
      [i, j - 1]
    end
    workers.reject! do |(i,j)|
      if j.zero?
        done << i
        thing.remove(i)
      end
    end
  end

  time
end


data = File.read("data/07_test.txt")
data = parse(data)
raise unless part1(data) == "CABDFE"
raise unless part2(data, 2, 0) == 15

data = File.read("data/07.txt")
data = parse(data)
p part1(data)
p part2(data, 5, 60)
