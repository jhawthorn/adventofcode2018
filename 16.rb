# frozen_string_literal: true

require 'time'
require 'set'

def parse_samples(data)
  data.scan(/Before: \[(.*)\]\n(.*)\nAfter:  \[(.*)\]/).map do |x,y,z|
    before = x.tr(',', ' ').split(' ').map(&:to_i)
    instr = y.split(' ').map(&:to_i)
    after = z.tr(',', ' ').split(' ').map(&:to_i)
    [before, after, instr]
  end
end

def parse_code(code)
  code.lines.map{|x| x.split.map(&:to_i) }
end

class CPU
  def initialize(registers=[0,0,0,0])
    @reg = registers.dup
  end

  def registers
    @reg
  end

  OPCODES = %i[
    addr
    addi
    mulr
    muli
    banr
    bani
    borr
    bori
    setr
    seti
    gtir
    gtri
    gtrr
    eqir
    eqri
    eqrr
  ]

  def opcode(op, a, b, c)
    case op
      when :addr
        @reg[c] = @reg[a] + @reg[b]
      when :addi
        @reg[c] = @reg[a] + b
      when :mulr
        @reg[c] = @reg[a] * @reg[b]
      when :muli
        @reg[c] = @reg[a] * b
      when :banr
        @reg[c] = @reg[a] & @reg[b]
      when :bani
        @reg[c] = @reg[a] & b
      when :borr
        @reg[c] = @reg[a] | @reg[b]
      when :bori
        @reg[c] = @reg[a] | b
      when :setr
        @reg[c] = @reg[a]
      when :seti
        @reg[c] = a
      when :gtir
        @reg[c] = (a > @reg[b]) ? 1 : 0
      when :gtri
        @reg[c] = (@reg[a] > b) ? 1 : 0
      when :gtrr
        @reg[c] = (@reg[a] > @reg[b]) ? 1 : 0
      when :eqir
        @reg[c] = (a == @reg[b]) ? 1 : 0
      when :eqri
        @reg[c] = (@reg[a] == b) ? 1 : 0
      when :eqrr
        @reg[c] = (@reg[a] == @reg[b]) ? 1 : 0
    end
  end
end

def matching_opcodes(before, expected, instr)
  CPU::OPCODES.select do |op|
    cpu = CPU.new(before.dup)
    cpu.opcode(op, *instr)
    cpu.registers == expected
  end
end

def part1(samples)
  samples.count do |(before, after, instr)|
    matching_opcodes(before, after, instr[1,3]).count >= 3
  end
end

def part2(samples, code)
  mapping = Array.new(16) { CPU::OPCODES.dup }

  samples.each do |(before, after, (opcode, *operands))|
    possible_codes = matching_opcodes(before, after, operands)
    mapping[opcode] &= possible_codes
  end

  opcodes = {}

  until mapping.all?(&:empty?)
    16.times do |i|
      if mapping[i].size == 1
        op = mapping[i][0]
        opcodes[i] = op
        mapping.each { |arr| arr.delete(op) }
      end
    end
  end

  cpu = CPU.new
  code.each do |(opcode, *operands)|
    op = opcodes[opcode]
    cpu.opcode(op, *operands)
  end

  cpu.registers[0]
end

raise unless matching_opcodes([3,2,1,1], [3,2,2,1], [2, 1, 2]) == [:addi, :mulr, :seti]

samples = parse_samples(File.read("data/16_samples.txt"))
code = parse_code(File.read("data/16_code.txt"))

p part1(samples)
p part2(samples, code)
