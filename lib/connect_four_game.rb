class String
  def red;            "\e[31m#{self}\e[0m"; end
  def green;          "\e[32m#{self}\e[0m"; end
  def white;           "\e[37m#{self}\e[0m"; end
end

WHITE = "\u26AA".white
GREEN = "\u26AB".green
RED = "\u26AB".red

class Cell
  attr_accessor :color
  attr_reader :row, :column
  
  def initialize(row, column)
    @row = row
    @column = column
    @color = WHITE
  end
end

class Board
  attr_accessor :cells
  
  def initialize
    @cells = {}
    
    for x in 1..6 do
      for y in 1..7 do
        @cells["#{x}#{y}"] = Cell.new(x,y)
      end
    end
  end
  
  def show_board
    x = 6
    6.times do
      for y in 1..7 do
        print self.cells["#{x}#{y}"].color
      end
      puts ''
      x -= 1
    end
  end
end

class Player
  attr_reader :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Game
  attr_accessor :board
  
  def initialize
    puts 'Would you like to play?'
    puts 'This is CONNECT FOUR Game'
    puts 'Two players are needed to play the game'
    puts 'Enter the name of Player1:'
    @player1 = Player.new(gets.chomp, GREEN)
    @current_turn = @player1
    puts "Hi, #{@player1.name}. You will be playing with green dots"
    puts 'Enter the name of Player2:'
    @player2 = Player.new(gets.chomp, RED)
    puts "Hi, #{@player2.name}. You will be playing with red dots"
    @board = Board.new
    puts "Lets start to play"
    @board.show_board
  end
  
  def start
    42.times do
      puts "#{@current_turn.name}, make your choice. Enter the number of column from 1 to 7"
      current_choice = gets.chomp.to_i
      current_choice = check(current_choice)
      
      while @board.cells["6#{current_choice}"].color != WHITE
        puts "This column is full. Choose the other one."
        current_choice = gets.chomp.to_i
        check(current_choice)
      end
      
      x = 1
      while @board.cells["#{x}#{current_choice}"].color != WHITE
        x += 1
      end
      
      @board.cells["#{x}#{current_choice}"].color = @current_turn.color
      @board.show_board
      
      if game_over?
        puts "#{@current_turn.name} won the game!"
        @current_turn = (@current_turn == @player1) ? @player2: @player1
        play_again?
        return
      end
      
      @current_turn = (@current_turn == @player1) ? @player2: @player1
    end
  end
  
  def check(current_choice)
    until current_choice.to_s.match?(/^([1-7])$/) do
      puts "Please, enter only number from 1 to 7"
      current_choice = gets.chomp.to_i
    end
    current_choice
  end
  
  def game_over?
    @board.cells.each_value do |cell|
      r = cell.row
      c = cell.column
      steps = [
              [[0,1], [0,2], [0,3]], 
              [[0,-1], [0,-2], [0,-3]], 
              [[1,0], [2,0], [3,0]], 
              [[-1,0], [-2,0], [-3,0]], 
              [[1,1], [2,2], [3,3]], 
              [[-1,-1], [-2,-2], [-3,-3]], 
              [[-1,1], [-2,2], [-3,3]], 
              [[1,-1], [2,-2], [3,-3]]
              ]
              
      if cell.color != WHITE
        steps.each do |arr|
          count = 1
          arr.each do |pair|
            count += 1 if @board.cells["#{r + pair[0]}#{c + pair[1]}"] != nil && @board.cells["#{r + pair[0]}#{c + pair[1]}"].color == cell.color
          end
          return true if count == 4
        end
      end
    end
    
    false
  end
  
  def play_again?
    puts "Would you like to play again (Y/N)?"
    answer = gets.chomp
    until answer.match?(/[Y,y,N,n]/) do
      puts "Use only Y or N. Would you like to play again (Y/N)?"
      answer = gets.chomp
    end
    if answer.match?(/[Y,y]/)
      @board = Board.new
      self.start
    end
  end
end

game = Game.new()
game.start
