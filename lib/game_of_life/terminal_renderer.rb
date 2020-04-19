require 'curses'

class TerminalRenderer
  def initialize(universe)
    @universe = universe
    Curses.init_screen
    Curses.curs_set(0)
  end

  def render_simulation
    window = Curses::Window.new(@universe.height, @universe.width, 0, 0)
    window.box("|", "-")

    loop do
      draw_frame(window, @universe.cells)
      @universe.tick
      sleep 1
    end

    win.close
  rescue => e
    Curses.close_screen
    puts e
  end

  def draw_frame(window, cells)
    window.clear

    cells.each do |cell|
      window.setpos(cell.y, cell.x)
      window.addstr("*")
    end

    window.refresh
  end
end
