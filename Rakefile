
class Day < Struct.new(:day, :filename)
  def run(quiet: false)
    options = {}
    options[:out] = "/dev/null" if quiet
    system("ruby", "--disable-gems", filename, options)
  end

  def to_s
    "Day #{day}"
  end
end

def each_day
  0.upto(25) do |day|
    filename = "%.2d.rb" % day

    if File.exist?(filename)
      yield Day.new(day, filename)
    end
  end
end

task default: :run
task :run do
  each_day do |day|
    puts day
    day.run
    puts
  end
end

task :benchmark do
  require 'benchmark'
  Benchmark.bm(7) do |x|
    each_day do |day|
      x.report(day.to_s) { day.run(quiet: true) }
    end
  end
end
