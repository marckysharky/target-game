require 'curses'

class Canvas
  include Curses

  attr_reader :canvas, :pos, :player, :space, :size, :canvas_size,
              :targets, :target, :crosshair

  def initialize
    @player      = '@'
    @space       = '-'
    @target      = '%'
    @crosshair   = '+'

    @size        = 3
    @targets     = 3
    @canvas_size = size**2
    @pos         = rand(canvas_size - 1)
    @canvas      = Array.new(canvas_size).map { space }

    init_screen
    update_position(:neutral)
    populate_canvas
  end

  def close
    close_screen
  end

  def render
    setpos(0,0)
    c = canvas.each_slice(size).each_with_object('') do |row, str|
      row.each { |col| str << render_cell(col) }
      str << render_newline
    end
    render_canvas(c)
  end

  def empty?
    canvas.find { |i| [crosshair, target].include?(i) }.nil?
  end

  def current_position
    @canvas[@pos]
  end

  def update_position(d)
    _p = case d
    when :up
      @pos - size
    when :down
      @pos + size
    when :right
      @pos + 1
    when :left
      @pos - 1
    when :neutral
      @pos
    when :fire
      @pos
    end

    return if _p > (@canvas.size - 1) || _p < 0

    @canvas[@pos] = @previous || space
    @pos = _p

    case @canvas[@pos]
    when crosshair
      @previous = target
      @canvas[@pos] = space
    when target
      if d == :fire
        @previous = nil
        @canvas[@pos] = space
      else
        @previous = target
        @canvas[@pos] = crosshair
      end
    when space
      @previous = nil
      @canvas[@pos] = player
    end
  end

  private

  def populate_canvas
    (0..canvas.size).to_a.shuffle.take(targets).each do |i|
      @canvas[i] = target
    end
  end

  def update_cell(x, y, v)
    @canvas[x][y] = v
  end

  def render_canvas(c)
    addstr(c)
    refresh
  end

  def render_cell(value)
    value.to_s.center(3)
  end

  def render_newline
    "\n"
  end
end
