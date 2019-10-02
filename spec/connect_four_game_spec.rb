require "./lib/connect_four_game.rb"

RSpec.describe Cell do
  describe "#initialize" do
    it "creates a new cell and attributes" do
      cell = Cell.new(1,2)
      expect(cell.row).to eql(1)
      expect(cell.column).to eql(2)
      expect(cell.color).to eql("\u26AA".white)
    end
  end
end

RSpec.describe Board do
  describe "#initialize" do
    it "creates a new board" do
      board = Board.new
      expect(board.cells.length).to eql(42)
      
      for x in 1..6 do
        for y in 1..7 do
          expect(board.cells["#{x}#{y}"].color).to eql("\u26AA".white)
        end
      end
    end
  end
end

RSpec.describe Player do
  describe "#initialize" do
    it "creates a new player and attributes" do
      player = Player.new("Mike","red")
      expect(player.name).to eql("Mike")
      expect(player.color).to eql("red")
    end
  end
end

RSpec.describe Game do
  game = Game.new()
  describe "#check" do
    it "checks whether a player chose a column in 1-7 diapason" do
      expect(game.check(1)).to eql(1)
      expect(game.check(7)).to eql(7)
    end
  end
  describe "#game_over?" do
    it "checks whether the game is over" do
      game.board.cells["11"].color = GREEN
      game.board.cells["12"].color = GREEN
      game.board.cells["13"].color = GREEN
      game.board.cells["14"].color = GREEN
      expect(game.game_over?).to eql(true)
      game.board.cells["11"].color = GREEN
      game.board.cells["22"].color = GREEN
      game.board.cells["33"].color = GREEN
      game.board.cells["44"].color = GREEN
      expect(game.game_over?).to eql(true)
    end
  end
end