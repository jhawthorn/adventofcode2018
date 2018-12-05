require 'set'
require 'time'

CHARS = (?a..?z)

def parse(input)
  input.strip
end

def process(data)
  data = data.dup
  CHARS.each do |c|
    data.gsub!("#{c}#{c.upcase}", "")
    data.gsub!("#{c.upcase}#{c}", "")
  end
  data
end

def part1(data)
  last = nil
  while last != data
    last = data
    data = process(data)
  end
  data.length
end

def part2(data)
  CHARS.map do |c|
    new_data = data.tr(c, '').tr(c.upcase, '')
    part1(new_data)
  end.min
end

data = parse("dabAcCaCBAcCcaDA")
raise unless part1(data) == 10
raise unless part2(data) == 4

data = parse(File.read("data/05.txt"))
p part1(data)
p part2(data)
