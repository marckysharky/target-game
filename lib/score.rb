class Score
  def self.call(time: , canvas_size: , target_size: )
    ((target_size * canvas_size.to_f) * time)
  end
end
