require 'canvas'
require 'score'

class Game
  attr_reader :canvas

  def initialize
    @canvas = Canvas.new
    @start  = nil
  end

  def play
    canvas.render
    @start = Time.now
    get_moves
    complete if canvas.empty?
  end

  def complete
    @finished = Time.now - @start
    canvas.close

    score = Score.call(time: @finished,
                       canvas_size: canvas.size,
                       target_size: canvas.targets)

    STDOUT.puts "Completed in #{@finished} seconds, score is #{score}"
  end

  def quit
    canvas.close
  end

  private

  def get_moves
    a = STDIN.getch

    return if a == "\u0003" || a == "\u0018"

    if a == 'a' || a == ' '
      fire
    elsif %w(A B C D).include?(a)
      move(a)
    end

    canvas.render

    get_moves unless canvas.empty?
  end

  def fire
    canvas.update_position(:fire)
  end

  def move(x)
    _p = case x
    when 'A'
      :up
    when 'B'
      :down
    when 'C'
      :right
    when 'D'
      :left
    end

    return unless _p

    canvas.update_position(_p)
  end
end
