module Launch
  GRAVITY = 9.801

  class BaseFrame
    attr_accessor :position
    attr_accessor :speed
    attr_accessor :time_to_explosion
  end

  class InitialFrame < BaseFrame
    XSPEEDRANGE = (0..3)
    YSPEEDRANGE = (5..15)
    ZSPEEDRANGE = (0.1..0.2)

    def initialize
      start_x                = (PADDING..XMAX-PADDING).any
      self.position          = {x: start_x, y: 0, z: 0}
      self.speed             = {x: XSPEEDRANGE.any, y: YSPEEDRANGE.any, z: ZSPEEDRANGE.any}
      self.time_to_explosion = (20..30).any
    end

    def alive?
      true
    end
  end

  class Frame < BaseFrame

    def initialize previous
      @previous = previous
      calc_speed
      calc_position
      self.time_to_explosion = @previous.time_to_explosion - 1
      try_bang
    end

    def alive?
      !time_to_explosion.zero?
    end

    def try_bang
      Bang.fire(position) if !alive?
    end

    def calc_position
      self.position = xyz do |coord|
        previous_terms[coord]
      end
      position.merge! y: (position[:y] + acceleration_term)
    end

    def calc_speed
      self.speed = xyz do |coord|
        @previous.speed[coord]
      end
      speed.merge! y: (speed[:y] - GRAVITY*CLOCK)
    end

    def previous_terms
      xyz do |coord|
        @previous.position[coord] + @previous.speed[coord]*CLOCK
      end
    end

    def acceleration_term
      0.5+GRAVITY*CLOCK**2
    end

    def xyz
      [:x, :y, :z].inject({}) do |memo, coord|
        memo.update Hash[coord, yield(coord)]
      end
    end
  end
end
