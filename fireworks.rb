#! /usr/bin/env ruby

require 'curses'
require 'io/console'

XMAX    = 80
PADDING = 20
YMAX    = 30
GRAVITY = 9.801

XSPEEDRANGE = (0..3)
YSPEEDRANGE = (5..15)
ZSPEEDRANGE = (0.1..0.2)

class Range
  def any
    rand(self)
  end
end

# start at base with random x coord
# select time-to-explosion
# select initial velocity random
#
#  increment time
#  calculate x,y,z coordinates
#  render the projected coordinate


#d(t) = d(0) + v(0)*t + 1/2+a*t^2
CLOCK = 0.1

class InitialFrame
  attr_accessor :position
  attr_accessor :speed
  attr_accessor :time_to_explosion

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

class Frame
  attr_accessor :position
  attr_accessor :speed
  attr_accessor :time_to_explosion

  def initialize previous
    @previous = previous
    calc_speed
    calc_position
    self.time_to_explosion = @previous.time_to_explosion - 1
  end

  def alive?
    !time_to_explosion.zero?
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


Curses::init_screen
Curses::nl
Curses::curs_set(0) # don't need to see that
def fire
  Thread.new do
    last_frame = InitialFrame.new
    loop do
      break unless last_frame.alive?
      x = last_frame.position[:x]
      y = YMAX - last_frame.position[:y]
      Curses::setpos y, x
      Curses::addstr "."
      Curses::refresh

      last_frame = Frame.new(last_frame)
      sleep CLOCK
    end
  end
end

fire

loop do
  char = STDIN.getch
  exit if char == "q"
  Curses::clear if char == "c"
  fire
end

# http://www.petesqbsite.com/sections/tutorials/tuts/perspective.html
# ----------------------------------------
# Formula to solve Sx
# ----------------------------------------
# Ez = distance from eye to the center of the screen
# Ex = X coordinate of the eye
# Px = X coordinate of the 3D point
# Pz = Z coordinate of the 3D point
#              Ez*(Px-Ex)
# Sx  = -----------------------  + Ex
#                Ez+Pz
#
# ----------------------------------------
# Formula to solve Sy
# ----------------------------------------
# Ez = distance from eye to the center of the screen
# Ey = Y coordinate of the eye
# Py = Y coordinate of the 3D point
# Pz = Z coordinate of the 3D point
#            Ez*(Py-Ey)
# Sy  = -------------------  + Ey
#              Ez+Pz
#
#
#
