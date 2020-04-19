class PatternReader
  def self.universe_from_pattern_file(path)
    cells = []

    max_x = max_y = 0
    File.open(path).each_with_index do |line, y|
      max_y = y if y > max_y
      line.split("").each_with_index do |char, x|
        max_x = x if x > max_x
        cells << Cell.alive(x, y) if char == "O"
      end
    end

    Universe.new(max_x + 1, max_y + 10, cells)
  end
end
