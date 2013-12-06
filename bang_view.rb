require_relative './curses_lib'

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
    include CursesLib

    def initialize origin
      @last_frame = Bang::InitialFrame.new(origin)
    end

    def render
      @last_frame = Bang::Frame.new(@last_frame)

      frames = [ @last_frame.last_frame.last_frame,
        @last_frame.last_frame,
        @last_frame ]

      frames.each do |frame|
        frame.particles.each do |part|
          color do
            Curses::setpos *translate(part)
            Curses::addstr "*"
          end
        end
      end
      return @last_frame.alive?
    end

    def translate(part)
      x = part[:x]
      y = YMAX - part[:y]
      [y, x]
    end

    def color
    options = [ BLUE_COLOR,    CYAN_COLOR, GREEN_COLOR,
                MAGENTA_COLOR, RED_COLOR,  YELLOW_COLOR,
                WHITE_COLOR                              ]

      attrib(Curses::color_pair(options.shuffle.first)) { yield }
    end

  end
end
