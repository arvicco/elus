module Elus
  class Game
    def initialize(options = {})
      rules_generator = options[:generator]
      @board = options[:board]
      @free = options[:free]
      raise Elus::Invalid, "Wrong Board or Free set: #{@board}, #{@free}" unless [@board, @free].all? {|set| Array === set}  # Check if all pieces are correct
      raise Elus::Invalid, "Wrong Game Pieces: #{@board}, #{@free}" unless (@board + @free).all? {|piece| Piece === piece}  # Check if all pieces are correct
      raise Elus::Invalid, "Wrong number of Game Pieces: #{@board}, #{@free}" unless @board.size >= 3 and @free.size == 3  # Check for correct Board/Free size
      raise Elus::Invalid, "Wrong Rules generator" unless rules_generator.respond_to? :generate_rules
      
      @rules = rules_generator.generate_rules
      test_rules
      count_moves
    end
    
    # Count Moves
    def count_moves
      @moves = @free.map do |piece| 
        count = @rules.count {|rule| piece == rule.apply(@board.last)}
        count > 0 ? "#{piece.name}(#{count})" : nil
      end.compact
    end
    
    def move(piece, new_free=nil)
      if new_free # The move was right!
        @board << piece
        @free = new_free
      else
        @free.delete(piece)
      end  
      test_rules
      count_moves
    end
    
    def state
      "Free:\n" + @free.join("\n") + "\nBoard:\n" + @board.join("\n") + "\n"
    end

    def hint
      "Rules(#{@rules.size}):\n" + @rules.map(&:name).join("\n") +"\n" +
      "Moves(#{@moves.size}):\n" + @moves.join("\n") + "\n"
    end
    
    def finished? 
      @board.size>=8  
    end
    
    def valid_move? piece 
      @free.include? piece
    end
    private 
    
    # Tests rules against current Game state, drops inconsistent rules
    def test_rules
      # Drop rule if not consistent with the Board sequence
      @rules.delete_if do |rule| 
        @board.each_cons(2).to_a.inject(false) do |delete, pieces|
          delete or rule.apply(pieces.first)!=pieces.last
        end
      end

      # Drop rule if applied to last Board Piece does not have single match among Free Pieces
      @rules.delete_if do |rule| 
        @free.count {|piece| piece == rule.apply(@board.last)} != 1
      end
    end

  end
  
  # An exception of this class indicates invalid input
  class Invalid < StandardError
  end
end