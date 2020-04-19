class Universe
  attr_reader :cells, :width, :height

  def initialize(width, height, cells)
    @width = width
    @height = height
    @cells = cells
    @grid = compute_grid
  end

  def tick
    instantiate_neighbors

    @cells = compute_next_generation

    prune_deceased

    @grid = compute_grid
  end

  def compute_grid
    grid = Array.new(@width) { Array.new(@height) }
    @cells.each do |cell|
      grid[cell.x][cell.y] = cell
    end

    grid
  end

  def compute_next_generation
    next_generation = []
    @cells.each do |cell|
      num_living_neighbors = alive_neighbors(cell)
      if cell.alive?
        next_generation << cell if num_living_neighbors == 2
        next_generation << cell if num_living_neighbors == 3
      else
        next_generation << Cell.alive(cell.x, cell.y) if num_living_neighbors == 3
      end
    end

    next_generation
  end

  def instantiate_neighbors
    new_cells  = []
    @cells.each do |cell|
      neighbor_coordinates_for(cell).each do |x, y|
        #if @grid.dig(x,y).nil?
        if @grid[x][y].nil?
          new_cells << @grid[x][y] = Cell.dead(x,y)
        end
      end
    end

    @cells.concat(new_cells)
  end

  def neighbor_coordinates_for(cell)
    coords_to_check = []
    coords_to_check << [cell.x - 1, cell.y - 1]
    coords_to_check << [cell.x - 1, cell.y]
    coords_to_check << [cell.x - 1, cell.y + 1]
    coords_to_check << [cell.x, cell.y - 1]
    coords_to_check << [cell.x, cell.y + 1]
    coords_to_check << [cell.x + 1, cell.y - 1]
    coords_to_check << [cell.x + 1, cell.y]
    coords_to_check << [cell.x + 1, cell.y + 1]

    coords_to_check.reject! { |x,y| x < 0 || y < 0 }
    coords_to_check.reject! { |x,y| x >= @grid.size || y >= @grid[0].size }

    coords_to_check
  end

  def alive_neighbors(cell)
    count = 0
    neighbor_coordinates_for(cell).each do |x,y|
      #count += 1 if @grid.dig(x,y)&.alive? == true
      count += 1 if @grid[x][y]&.alive? == true
    end

    count
  end

  def prune_deceased
    @cells = @cells.select { |cell| cell.alive? }
  end
end
