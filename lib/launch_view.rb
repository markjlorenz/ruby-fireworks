require_relative './curses_lib'
module Launch
  def self.fire
    Thread.new do
      view = Launch::View.new
      loop do
        break unless view.render
        sleep CLOCK
      end
    end
  end

  class View
    include CursesLib

    def initialize
      @last_frame = Launch::InitialFrame.new
    end

    def render
      burnt do
        Curses::setpos *translate_frame
        Curses::addstr "."
      end

      @last_frame = Launch::Frame.new(@last_frame)
      white do
        Curses::setpos *translate_frame
        Curses::addstr "."
      end
      return @last_frame.alive?
    end

    def translate_frame
      x = @last_frame.position[:x]
      y = YMAX - @last_frame.position[:y]
      [y, x]
    end

    def white
      attrib(Curses::A_BOLD) { yield }
    end

    def burnt
      attrib(Curses::color_pair(ORANGE_COLOR)) { yield }
    end

  end
end
