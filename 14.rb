require 'time'
require 'set'

def calculate
  return enum_for(__method__) unless block_given?

  scoreboard = 37.digits.reverse

  scoreboard.each do |v|
    yield v
  end

  pos0 = 0
  pos1 = 1

  loop do
    val0 = scoreboard[pos0]
    val1 = scoreboard[pos1]

    sum = val0 + val1
    if sum >= 10
      yield sum / 10
      scoreboard << sum / 10

      yield sum % 10
      scoreboard << sum % 10
    else
      yield sum
      scoreboard << sum
    end

    len = scoreboard.length
    pos0 += 1 + val0
    pos0 %= len
    pos1 += 1 + val1
    pos1 %= len

    #scoreboard.each.with_index do |x, i|
    #  if i == elves[0]
    #    print "(#{x})"
    #  elsif i == elves[1]
    #    print "[#{x}]"
    #  else
    #    print " #{x} "
    #  end
    #end
    #puts
  end
end

def part1(after, n=10)
  iter = calculate
  after.times { iter.next }
  n.times.map { iter.next }.join
end

def part2(value)
  value = value.digits.reverse
  len = value.length
  digits = []

  n = 0
  calculate do |v|
    n += 1
    digits << v
    digits = digits.last(len)

    if digits == value
      return n - len
    end
  end
end

raise unless part1(9)    == "5158916779"
raise unless part1(5)    == "0124515891"
raise unless part1(18)   == "9251071085"
raise unless part1(2018) == "5941429882"

p part1(652601)

raise unless part2(51589) == 9
raise unless part2(59414) == 2018

p part2(652601)
