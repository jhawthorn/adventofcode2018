# frozen_string_literal: true

require 'time'
require 'set'

def parse(data)
  data.lines.map(&:chop)
end

class Unit < Struct.new(:map, :x, :y, :type, :hp, :atk, :alive)
  def <=>(other)
    pos.reverse <=> other.pos.reverse
  end

  def elf?
    type == "E"
  end

  def goblin?
    type == "G"
  end

  def pos
    [x,y]
  end

  def move(newpos)
    raise "invalid move" unless map.at(newpos) == '.'
    remove_from_map
    self.x, self.y = newpos
    add_to_map
  end

  def adjacent_enemies
    map.adjacent_to(pos).map do |adj|
      map.unit_at[adj]
    end.compact.select do |unit|
      unit.type == enemy_type
    end
  end

  def next_to_enemy?
    adjacent_enemies.any?
  end

  def attack
    adjacent_enemies = self.adjacent_enemies
    return unless adjacent_enemies.any?

    target_hp = adjacent_enemies.map(&:hp).min
    target = adjacent_enemies.select{|u| u.hp == target_hp }.sort.first

    #p target
    target.damage(atk)
    #puts "#{self.inspect} attacks #{target.inspect}"
  end

  def damage(n)
    self.hp -= n
    if hp <= 0
      remove_from_map
      self.alive = false
    end
  end

  def remove_from_map
    map.set(pos, '.')
    map.unit_at.delete(pos)
  end

  def add_to_map
    map.set(pos, type)
    map.unit_at[pos] = self
  end

  def enemy_type
    elf? ? "G" : "E"
  end

  def inspect
    "#< #{type} at #{x},#{y} (#{hp} HP) >"
  end
end

class Map
  attr_reader :unit_at

  def all_units
    @units
  end

  def units
    @units.select(&:alive)
  end

  def initialize(map, elf_attack)
    @map = map
    @units = []

    @map.each.with_index do |line, y|
      line.each_char.with_index do |c, x|
        if c == "E"
          @units << Unit.new(self, x, y, "E", 200, elf_attack, true)
        elsif c == "G"
          @units << Unit.new(self, x, y, "G", 200, 3, true)
        end
      end
    end

    @unit_at = {}
    units.each(&:add_to_map)
  end

  def adjacent_to((x, y))
    [
      [x+1,y],
      [x,y+1],
      [x-1,y],
      [x,y-1]
    ]
  end

  def set((x,y), value)
    @map[y][x] = value
  end

  def at((x,y))
    @map[y][x]
  end

  def each_min_distance(source, destinations)
    return enum_for(__method__, source, destinations) unless block_given?

    seen = Set.new

    destinations = Set.new(destinations.map{|(x,y)| (y << 16) | x })

    min_distance = nil

    dist = 0
    queue = []
    next_queue = [source]

    while !next_queue.empty?
      queue = next_queue
      next_queue = []

      queue.each do |pos|
        return if min_distance && dist > min_distance

        x, y = pos

        hash = (y << 16) | x
        next if seen.include?(hash)
        seen.add(hash)

        if destinations.include?(hash)
          yield pos, dist

          min_distance = dist
        end

        next_queue << [x+1,y] if @map[y][x+1] == "."
        next_queue << [x-1,y] if @map[y][x-1] == "."
        next_queue << [x,y+1] if @map[y+1][x] == "."
        next_queue << [x,y-1] if @map[y-1][x] == "."
      end

      dist += 1
    end

    nil
  end

  def to_s
    @map.join("\n")
  end
end

class Game
  attr_reader :rounds

  def initialize(data, elf_attack=3)
    @map = Map.new(data.map(&:dup), elf_attack)
    @done = false
    @rounds = 0
  end

  def units
    @map.units
  end

  def all_units
    @map.all_units
  end

  def targets_for(type)
    units.select{|u| u.type == type }.map(&:pos).flat_map do |x, y|
      [
        [x+1,y],
        [x,y+1],
        [x-1,y],
        [x,y-1]
      ]
    end.select do |pos|
      @map.at(pos) == '.'
    end
  end

  def pick_move(x,y,type)
    target_type = type == "G" ? "E" : "G"
    targets = targets_for(target_type).uniq
    targets = @map.each_min_distance([x,y], targets).to_a

    return nil if targets.empty?

    # Find nearest
    target = targets.min_by{ |pos,dist| pos.reverse }
    target = target[0]

    moves = @map.adjacent_to([x,y]).select do |pos|
      @map.at(pos) == '.'
    end

    moves = @map.each_min_distance(target, moves).to_a

    move = moves.min_by do |pos, distance|
      pos.reverse
    end

    move && move[0]
  end

  def round
    return :done if @done

    @map.units.sort.each do |unit|
      next unless unit.alive

      if @map.units.none? { |u| u.type == unit.enemy_type }
        @done = true
        return :done
      end

      #if unit.next_to_enemy?
        #puts "#{unit.inspect} is next to enemy"
      #end
      unless unit.next_to_enemy?
        move = pick_move(unit.x,unit.y,unit.type)

        unit.move(move) if move
      end

      unit.attack
    end

    @rounds += 1

    nil
  end

  def winner
    @map.units.first.type
  end

  def done?
    !!@done
  end

  def any_dead_elves?
    !@map.all_units.select(&:elf?).all?(&:alive)
  end

  def to_s
    @map.to_s
  end

  def result
    rounds * units.map(&:hp).sum
  end
end

def part1(data)
  game = Game.new(data)
  game.round while !game.done?
  game.result
end

def part2(data)
  results = {}

  lowest_attack =
    (4..100).bsearch do |elf_attack|
      game = Game.new(data, elf_attack)

      game.round while !game.done? && !game.any_dead_elves?

      results[elf_attack] = game.result if game.done?

      !game.any_dead_elves?
    end

  results[lowest_attack]
end

data = parse(File.read("data/15.txt"))

p part1(data)
p part2(data)
