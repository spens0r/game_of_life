require "game_of_life/cell"

RSpec.describe Cell do
  describe "self.alive" do
    it "initializes alive" do
      cell = Cell.alive(0,0)

      expect(cell.alive?).to eq(true)
    end
  end

  describe "self.dead" do
    it "initialized dead" do
      cell = Cell.dead(0,0)

      expect(cell.alive?).to eq(false)
    end
  end

  it "knows where it is" do
    cell = Cell.alive(1,2)#

    expect(cell.x).to eq(1)
    expect(cell.y).to eq(2)
  end

  describe "#kill" do
    it "kills the cell" do
      cell = Cell.alive(0,0)
      cell.kill

      expect(cell.alive?).to eq(false)
    end
  end
end
