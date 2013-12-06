module Launch
  GRAVITY = 9.801

  class BaseFrame
    attr_accessor :position
    attr_accessor :speed
    attr_accessor :time_to_explosion
    attr_accessor :last_frame
  end

  class InitialFrame < BaseFrame
    EXPLOSIONRANGE = (20..30)
    YSPEEDMAX      = Math.sqrt(2 * (YMAX-PADDING) * GRAVITY)
    XSPEEDRANGE    = (0..3)
    YSPEEDRANGE    = (5..YSPEEDMAX)
    ZSPEEDRANGE    = (0.1..0.2)

    def initialize
      start_x            = (PADDING..XMAX-PADDING).any
      @position          = {x: start_x, y: 0, z: 0}
      @speed             = {x: XSPEEDRANGE.any, y: YSPEEDRANGE.any, z: ZSPEEDRANGE.any}
      @time_to_explosion = EXPLOSIONRANGE.any
      @last_frame        = self
    end

    def alive?
      true
    end
  end

  class Frame < BaseFrame
    DUDHEIGHT = 2

    def initialize previous
      @last_frame = previous
      calc_speed
      calc_position
      @time_to_explosion = @last_frame.time_to_explosion - 1
      try_bang
    end

    def alive?
      !time_to_explosion.zero?
    end

    private

    def dud?
      position[:y] < DUDHEIGHT && !alive?
    end

    def try_bang
      Bang.fire(position) if !alive? && !dud?
    end

    def calc_position
      self.position = xyz do |coord|
        previous_terms[coord]
      end
      position.merge! y: (position[:y] + acceleration_term)
    end

    def calc_speed
      self.speed = xyz do |coord|
        last_frame.speed[coord]
      end
      speed.merge! y: (speed[:y] - GRAVITY*CLOCK)
    end

    def previous_terms
      xyz do |coord|
        last_frame.position[coord] + last_frame.speed[coord]*CLOCK
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
