$LOAD_PATH.unshift File.expand_path('./lib')
require 'rubygems'
require 'bundler/setup'
require 'game'

begin
  game = Game.new

  for i in %w[HUP INT QUIT TERM]
    trap(i) do |sig|
      game.quit
      exit sig
    end
  end

  game.play
rescue => e
  game.quit if game
  STDOUT.puts e
end
