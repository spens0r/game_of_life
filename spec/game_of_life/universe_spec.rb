RSpec.describe Universe do
  describe "prune_deceased" do
    it "removes cells that are dead" do
      live_cell = Cell.alive(0,0)
      dead_cell = Cell.alive(0,1)
      dead_cell.kill

      universe = Universe.new(2,2,[live_cell, dead_cell])
      universe.prune_deceased

      expect(universe.cells).to eq([live_cell])
    end
  end

  describe "instantiate_neighbors" do
    it "instantiates dead neighbors around live neighbors" do
      center_cell = Cell.alive(1,1)
      u = Universe.new(3, 3, [center_cell])

      u.instantiate_neighbors

      expect(u.cells.size).to eq(9)
      expect(u.cells.select { |cell| cell.alive? }.count).to eq (1)
      expect(u.cells.reject { |cell| cell.alive? }.count).to eq (8)
    end

    it "doesn't touch cells that don't neighbor a live cell" do
      center_cell = Cell.alive(0,0)
      u = Universe.new(3, 3, [center_cell])

      u.instantiate_neighbors

      expect(u.cells.size).to eq(4)
      expect(u.cells.select { |cell| cell.alive? }.count).to eq (1)
      expect(u.cells.reject { |cell| cell.alive? }.count).to eq (3)
    end
  end

  describe "next_generation" do
    it "kills cells with fewer than 2 living neighbors" do
      cell = Cell.alive(1,1)
      neigh = Cell.alive(0,1)
      u = Universe.new(3, 3, [cell, neigh])

      next_generation = u.compute_next_generation
      expect(next_generation.size).to eq(0)
    end

    it "kills cells with greater than 3 living neighbors" do
      cell = Cell.alive(1,1)
      neigh1 = Cell.alive(0,1)
      neigh2 = Cell.alive(1,0)
      neigh3 = Cell.alive(2,1)
      neigh4 = Cell.alive(1,2)
      u = Universe.new(3, 3, [cell, neigh1, neigh2, neigh3, neigh4])

      binding.pry
      next_generation = u.compute_next_generation
      expect(next_generation.size).to eq(4)
      expect(next_generation.select { |cell| cell.x == 1 && cell.y == 1 }).to be_empty
    end

    it "brings cells with exactly 3 living neighbors to life" do
      cell = Cell.dead(0,0)
      neigh1 = Cell.alive(0,1)
      neigh2 = Cell.alive(1,0)
      neigh3 = Cell.alive(1,1)
      u = Universe.new(3, 3, [cell, neigh1, neigh2, neigh3])

      next_generation = u.compute_next_generation
      expect(next_generation.size).to eq(4)
      expect(next_generation.find { |cell| cell.x == 0 && cell.y == 0 }.alive?).to eq(true)
    end

    it "allows cells with 2 living neighbors to survive" do
      cell = Cell.alive(0,0)
      neigh1 = Cell.alive(0,1)
      neigh2 = Cell.alive(1,0)
      u = Universe.new(3, 3, [cell, neigh1, neigh2])

      next_generation = u.compute_next_generation
      expect(next_generation.size).to eq(3)
      expect(next_generation).to include(cell)
    end

    it "allows cells with 3 living neighbors to survive" do
      cell = Cell.alive(0,0)
      neigh1 = Cell.alive(0,1)
      neigh2 = Cell.alive(1,0)
      neigh3 = Cell.alive(1,1)
      u = Universe.new(3, 3, [cell, neigh1, neigh2, neigh3])

      next_generation = u.compute_next_generation
      expect(next_generation.size).to eq(4)
      expect(next_generation).to include(cell)
    end
  end

  describe "alive_neighbors" do
    it "counts a cells neighbors" do
      c1 = Cell.alive(1,1)
      c2 = Cell.alive(0,0)
      c3 = Cell.alive(0,2)
      c4 = Cell.alive(2,0)
      c5 = Cell.alive(2,2)

      u = Universe.new(3,3,[c1,c2,c3,c4,c5])
      expect(u.alive_neighbors(c1)).to eq(4)
      expect(u.alive_neighbors(c2)).to eq(1)
    end
  end
end
