module Bang
  class BaseFrame # you know you love it, "base" ;-)
    attr_reader :particles
    attr_reader :speed
    attr_reader :time_to_live
    attr_reader :last_frame
  end

  class InitialFrame < BaseFrame
    SPEEDRANGE      = (3..8)
    TIMETOLIVERANGE = (5..15)

    def initialize origin
      @speed        = SPEEDRANGE.any
      @time_to_live = TIMETOLIVERANGE.any
      @particles    = Array.new(10, {x: origin[:x], y: origin[:y],  z: origin[:z]})
      @last_frame   = self
    end

    def alive?
      true
    end
  end

  class Frame < BaseFrame

    def initialize last_frame
      @angle_increment = 360 / last_frame.particles.size

      @speed        = last_frame.speed
      @time_to_live = last_frame.time_to_live - 1
      @last_frame   = last_frame
      @particles    = calc_particles
    end

    def calc_particles
      # calculation intentionally not a linearly growning circle
      @last_frame.particles.map.with_index do |particle, idx|
        {
          x: Math.cos(@angle_increment * idx) * CLOCK * speed + particle[:x],
          y: Math.sin(@angle_increment * idx) * CLOCK * speed + particle[:y],
        }
      end
    end

    def alive?
      !time_to_live.zero?
    end

  end
end
