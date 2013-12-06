#! /usr/bin/env ruby

Thread.abort_on_exception = true

require 'curses'
require 'io/console'

YMAX, XMAX = STDIN.winsize
CLOCK   = 0.1
PADDING = 20

require_relative './curses_lib'
require_relative './launch'
require_relative './bang'
require_relative './launch_view'
require_relative './bang_view'

Curses::init_screen

# yes, I am bad, and I want to date your daughter.
class Range
  def any
    rand(self)
  end
end

Launch.fire

Thread.new do
  loop do
    Curses::refresh
    Curses::clear
    sleep CLOCK
  end
end

loop do
  char = STDIN.getch
  exit if char == "q"
  Curses::clear if char == "c"
  Launch.fire
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
