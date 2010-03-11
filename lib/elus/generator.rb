module Elus
  # Rules Generators
  class Generator
    def generate_rules
      []
    end
    
    # iterates through all permutations of string chars with 2 dots  
    def permutate(string='01!=')
      string.split(//).product(['.'],['.']).map {|set| set.permutation.to_a.uniq}.flatten(1).map {|chars| chars.join}
    end
  end

  class EmptyGenerator < Generator
  end

  class Turn1Generator < Generator
    def generate_rules
      yes_branches = permutate
      ['...'].product(yes_branches).map do |condition, yes| 
        Rule.new(Piece.create(condition), Piece.create(yes))
      end
    end
  end

  class Turn2Generator < Generator
    def generate_rules
      conditions = permutate('1')
      branches = permutate.map {|code| [code, Piece.different(code)]}
      conditions.product(branches.uniq).map  do |condition, yes_no| 
        yes,no = yes_no
        Rule.new(Piece.create(condition), Piece.create(yes), Piece.create(no))
      end  
    end
  end

  class Turn3Generator < Generator
    def generate_rules
      conditions = permutate('1')
      yes_branches = permutate
      no_branches = permutate
      conditions.product(yes_branches, no_branches).map  do|condition, yes, no| 
        Rule.new(Piece.create(condition), Piece.create(yes), Piece.create(no))
      end  
    end
  end

end
