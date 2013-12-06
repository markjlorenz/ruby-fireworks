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
    ORANGE       = 20
    ORANGE_COLOR = 20
    Curses.start_color
    Curses.init_color ORANGE, 254, 254, 0
    Curses.init_pair  ORANGE_COLOR, ORANGE, Curses::COLOR_BLACK

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
      attrib Curses::A_BOLD do yield end
    end

    def burnt
      attrib Curses::color_pair(ORANGE_COLOR) do yield end
    end

    def attrib *attributes
      attributes.each do |attribute|
        Curses.attron  attribute
      end
      yield
      attributes.each do |attribute|
        Curses.attroff  attribute
      end
    end

  end
end
