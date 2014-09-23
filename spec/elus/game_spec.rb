require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )

  def generator_stub
    stub('generator', :generate_rules => [])
  end

  def should_be_in(string, *messages)
    messages.each do |msg|
      string.split("\n").should include(msg)
    end  
  end

module Elus
  describe Game do
    before :each do
       @free = [ Piece.create("BGC"),
                 Piece.create("sgd"),
                 Piece.create("syc") ]
       @board = [Piece.create("BYD"),
                 Piece.create("SYD"),
                 Piece.create("BGD") ]
       @pieces = @free + @board
       @new =   [ Piece.create("BYC"),
                 Piece.create("BYD"),
                 Piece.create("SGC") ]
    end

    context  "creating" do
      it "should raise exception if not enough Pieces" do
        lambda{Game.new(:generator=>generator_stub)}.should raise_error(Invalid)
        lambda{Game.new(:free=>@free, :generator=>generator_stub)}.should raise_error(Invalid)
        lambda{Game.new(:board=>@board,:generator=>generator_stub)}.should raise_error(Invalid)
        (0..2).each {|n| lambda{Game.new(:free=>@pieces[0,n], :board=>@board, :generator=>@wrong_generator)}.should raise_error(Invalid)}
        (0..2).each {|n| lambda{Game.new(:free=>@free, :board=>@pieces[3,n], :generator=>@wrong_generator)}.should raise_error(Invalid)}
      end
      
      it "should raise exception if it is given wrong generator_stub" do
        lambda{Game.new(:free=>@free, :board=>@board, :generator=>@wrong_generator)}.should raise_error(Invalid)
      end
      
      it "should contain Free, Board and matching Piece name in Game state" do
        CODES.each do |code, name|
          code1, name1 = CODES.to_a[rand(CODES.size-1)]
          free = @pieces[0..1] << Piece.create(code)
          board = @pieces[2..3] << Piece.create(code1)
          game = Game.new(:free=>free, :board=>board, :generator=>generator_stub)
          should_be_in game.state, name, name1, "Free:", "Board:"
        end
      end
    end
    
    context 'generating hints' do
      it "should generate appropriate hints about Rules" do
        game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
        should_be_in game.hint,  'Rules(2):',
                                  'If last Piece is Any Piece, Lozenge Piece is next',
                                  'If last Piece is Any Piece, Same shape Piece is next'
      end
      it "should generate appropriate hints about Moves" do
        game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
        should_be_in game.hint,  'Moves(1):',
                                 'Small Green Lozenge(2)'
      end
    end
    context 'making moves' do
      it 'should add moved piece to board upon right move' do
        game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
        piece = Piece.create('SGD')
        game.move(piece, @new)
        game.state.should =~ Regexp.new("Board:[\\w\\s]*#{piece.name}")
      end
      it 'should reset free and moves sets upon right move' do
        game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
        piece = Piece.create('SGD')
        game.move(piece, @new)
        game.state.should =~ Regexp.new('Free:\s'+@new.map(&:name).join('\s'))
        game.hint.should =~ /Moves\(1\):\sBig Yellow Lozenge/
      end
      it 'should not add moved piece to board upon wrong move' do
        game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
        piece = Piece.create('BGC')
        game.move(piece)
        game.state.should_not =~ Regexp.new("Board:[\\w\\s]*#{piece.name}")
      end
      it 'should remove moved piece from free set upon wrong move' do
        game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
        piece = Piece.create('BGC')
        game.move(piece)
        game.state.should_not =~ Regexp.new('Free:[\s.]*'+piece.name+'[\s.]Board')
        game.hint.should =~ /Moves\(1\):\sSmall Green Lozenge/
      end
    end
    context 'predicate testing' do
      it 'should be finished if more than 8 pieces on the board' do
        game = Game.new(:free=>@free, :board=>@board+@board+@board, :generator=>Turn1Generator.new)
        game.should be_finished
      end
      it 'should consider any free piece a valid move' do
        ['BGC', 'SGD', 'SYC'].each do |code|
          game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
          piece = Piece.create(code)
          game.should be_valid_move(piece)
        end
      end
      it 'should not consider any non-free piece a valid move' do
        CODES.each do |code, name|
          game = Game.new(:free=>@free, :board=>@board, :generator=>Turn1Generator.new)
          piece = Piece.create(code)
          game.should_not be_valid_move(piece) unless @free.include? piece
        end
      end
    end
  end
end
