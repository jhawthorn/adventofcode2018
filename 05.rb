require 'set'
require 'time'

CHARS = (?a..?z)
REPLACEMENTS = CHARS.flat_map { |c| [c + c.upcase, c.upcase + c] }

def parse(input)
  input.strip
end

def part1(data)
  last = -1
  while last != data.length
    last = data.length
    REPLACEMENTS.each do |r|
      data.gsub!(r, "")
    end
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
