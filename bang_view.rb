module Bang
  def self.fire(origin)
    Thread.new do
      view = Bang::View.new(origin)
      loop do
        break unless view.render
        sleep CLOCK
      end
    end
  end

  class View
    def initialize origin
      @last_frame = Bang::InitialFrame.new(origin)
    end

    def render
      @last_frame.particles.each do |part|
        Curses::setpos *translate(part)
        Curses::addstr "."
      end
      @last_frame = Bang::Frame.new(@last_frame)
      return @last_frame.alive?
    end

    def translate(part)
      x = part[:x]
      y = YMAX - part[:y]
      [y, x]
    end

  end
end
