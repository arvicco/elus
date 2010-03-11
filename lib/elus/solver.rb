module Elus
  class Solver
    attr_reader :game
    
    def initialize(stdin, stdout)
      @stdin = stdin  
      @stdout = stdout
    end
    
    def start (generator)
      @generator = generator
      @stdout.puts "Welcome to Elus Solver!"
      @stdout.puts "Enter Game state:"
    end
    
    # Inputs Game state either from given code string or interactively (from @stdin)
    def input_state(codes=nil)
      if codes
        pieces = codes.split("\n").map {|code| Piece.create(code)}.compact
        free=pieces[0..2]
        board=pieces[3..-1]
      else  
        free = input_pieces "Free", 3
        board = input_pieces "Board"
      end
      @game = Game.new(:free=>free, :board=>board, :generator=>@generator)
    end
    
    def input_pieces(label, num=10)
      pieces = []
      while pieces.size < num and piece = input_piece(:prompt => "Enter #{label} Piece code (#{pieces.size+1}):") do
        @stdout.puts "You entered #{label} Piece (#{pieces.size+1}): #{piece.name}"
        pieces << piece 
      end
      pieces
    end
    
    # Inputs single correct code from stdin, returns correct piece or nil if break requested. Rejects wrong codes.
    def input_piece(options = {})
      loop do
        @stdout.puts options[:prompt] || "Enter code:"
        code = @stdin.gets
        return nil if code == "\n"
        if piece = Piece.create(code)
          return piece
        else
          @stdout.puts options[:failure] || "Invalid code: #{code}"
        end
      end
    end
    
    def make_moves
      while not @game.finished?
        make_move
      end
    end  
      
    def make_move
      @stdout.puts @game.state
      @stdout.puts @game.hint
      piece = input_piece(:prompt => "Make your move:")
      if piece and @game.valid_move? piece
        @stdout.puts "You moved: #{piece.name}"
        @stdout.puts "Was the move right(Y/N)?:"
        if @stdin.gets =~ /[Yy]/
          @stdout.puts "Great, now enter new Free set:"
          free = input_pieces "Free", 3
          @game.move piece, free
        else
          @stdout.puts "Too bad"
          @game.move piece
        end
      elsif piece
        @stdout.puts "Wrong move (not in free set): #{piece.name}"
      else 
        @stdout.puts "Wrong move (no piece given)"
      end
    end
    
    def state; @game.state end
    def hint; @game.hint end
    
  end #Solver
end
