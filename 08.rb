Node = Struct.new(:children, :metadata) do
  def part1
    children.sum(&:part1) + metadata.sum
  end

  def part2
    return metadata.sum if children.empty?

    metadata.sum do |i|
      if i > 0 && i <= children.size
        children[i - 1].part2
      else
        0
      end
    end
  end
end

def parse_node(data)
  children, metadata = data.shift(2)
  Node.new(
    children.times.map { |n| parse_node(data) },
    data.shift(metadata)
  )
end

def parse(input)
  parse_node(input.split.map(&:to_i))
end

root = parse(File.read("data/08_test.txt"))
p root.part1
p root.part2

root = parse(File.read("data/08.txt"))
p root.part1
p root.part2
