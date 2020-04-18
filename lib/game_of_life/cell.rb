class Cell
  attr_reader :x, :y

  def initialize(x, y, state)
    @x, @y  = x, y
    @state = state
  end

  def self.alive(x, y)
    Cell.new(x, y, :alive)
  end

  def self.dead(x, y)
    Cell.new(x, y, :dead)
  end

  def alive?
    @state == :alive
  end

  def kill
    @state = :dead
  end
end
