require 'time'
require 'set'

def parse(data)
  lines = data.lines.map(&:strip)
  initial = lines.shift
  lines.shift
  lines.map! {|x| x.split(" => ") }
  [initial, Hash[lines]]
end

def step(initial, map)
  (["."]*2 + initial.chars + ["."]*2).each_cons(5).map do |chars|
    map[chars.join] || "."
  end.join
end

def normalize(zero, state)
  size = state.size
  state = state.gsub(/\A\.*/, "...")
  zero += state.size - size

  state = state.gsub(/\.*\z/, "...")

  [zero, state]
end

def calculate(data, times)
  initial, map = data
  seen = {}

  zero = 0
  state = initial

  zero, state = normalize(zero, state)

  iter = 0
  while iter < times
    zero, state = normalize(zero, state)

    if seen[state]
      olditer, old0 = seen[state]
      skip = iter - olditer
      skippable = ((times - iter - 1) / skip)
      iter += skip * skippable
      zero += (zero - old0) * skippable
    end
    seen[state] ||= [iter, zero]

    state = step(state, map)

    iter += 1
  end

  state.chars.map.with_index do |x, i|
    if x == "."
      0
    else
      v = i - zero
    end
  end.sum
end

data = parse(File.read("data/12_test.txt"))
raise unless calculate(data, 20) == 325

data = parse(File.read("data/12.txt"))
p calculate(data, 20)
p calculate(data, 50000000000)
