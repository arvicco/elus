module Elus
  class Rule
    def initialize(condition, yes, no=nil)
      @condition = Piece === condition ? condition : Piece.create(condition)
      raise Invalid,  "Wrong condition" unless @condition
      @yes = Piece === yes ? yes : Piece.create(yes)
      raise Invalid,  "Wrong yes branch" unless @yes
      @no = if Piece === no 
              no 
            elsif Piece.create(no)
              Piece.create(no) 
            elsif no
              raise( Invalid, "Wrong no branch")
            else
              nil
            end
    end
    
    # Returns full text name of this Rule
    def name
      "If last Piece is #{@condition.name} Piece, #{@yes.name} Piece is next" + if @no then ", otherwise #{@no.name} Piece is next" else "" end
    end
    
    def to_s; name end
    
    def apply(other)
      piece = Piece === other ? other : Piece.create(other)
      return nil unless piece
      if piece == @condition
        piece * @yes
      else
        piece * @no
      end
    end
  end
end