module CursesLib

  Curses.nl
  Curses.curs_set(0) # don't need to see that

  Curses.start_color

  BLUE_COLOR = 30
  Curses.init_pair  BLUE_COLOR, Curses::COLOR_BLUE, Curses::COLOR_BLACK
  CYAN_COLOR = 40
  Curses.init_pair  CYAN_COLOR, Curses::COLOR_CYAN, Curses::COLOR_BLACK
  GREEN_COLOR = 50
  Curses.init_pair  GREEN_COLOR, Curses::COLOR_GREEN, Curses::COLOR_BLACK
  MAGENTA_COLOR = 60
  Curses.init_pair  MAGENTA_COLOR, Curses::COLOR_MAGENTA, Curses::COLOR_BLACK
  RED_COLOR = 70
  Curses.init_pair  RED_COLOR, Curses::COLOR_RED, Curses::COLOR_BLACK
  YELLOW_COLOR = 80
  Curses.init_pair  YELLOW_COLOR, Curses::COLOR_YELLOW, Curses::COLOR_BLACK
  WHITE_COLOR = 90
  Curses.init_pair  WHITE_COLOR, Curses::COLOR_WHITE, Curses::COLOR_BLACK

  ORANGE       = 20
  ORANGE_COLOR = 20
  Curses.init_color ORANGE, 254, 254, 0
  Curses.init_pair  ORANGE_COLOR, ORANGE, Curses::COLOR_BLACK

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
