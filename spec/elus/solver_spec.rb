require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )

module Elus
  include ElusTest
  
  def create_solver(options={})
    @stdout = options[:stdout] || mock('stdout').as_null_object
    @stdin = options[:stdin] || mock('stdin')
    @stdin.stub(:gets).and_return(*options[:input]) if options[:input]
    @solver = Solver.new(@stdin, @stdout)
  end
  
  def start_solver(options={})
    create_solver(options)
    @solver.start(options[:generator] || stub('generator', :generate_rules => []))
  end

  # sets expectation for stdout to receive strictly ordered sequence of exact messages
  def stdout_should_receive(*messages)
    messages.each do |message|
      @stdout.should_receive(:puts).with(message).once.ordered
    end
  end

  # sets expectation for stdout to receive message(s) containing all of the patterns (unordered)
  def stdout_should_include(*patterns)
    patterns.each do |pattern|
      re = Regexp === pattern ? pattern : Regexp.new(Regexp.escape(pattern))
      @stdout.should_receive(:puts).with(re).at_least(:once)
    end
  end
 
  describe Solver do  
    context 'starting up' do
      it 'should send a welcome message' do
        create_solver
        stdout_should_receive("Welcome to Elus Solver!")
        @solver.start(stub('generator', :generate_rules => []))
      end
      
      it 'should prompt for Game state' do
        create_solver
        stdout_should_receive("Enter Game state:")
        @solver.start(stub('generator', :generate_rules => []))
      end
    end
  
    context 'inputing single Piece' do
      it 'should return corresponding Piece for each correct code entered' do
        CODES.each do |code, name|
          start_solver
          @stdin.stub(:gets).and_return(code)
          piece = @solver.input_piece
          piece.name.should == name
        end
      end
      it 'should inform about invalid codes and return nil if interrupted' do
        WRONG_CODES.each do |code|
          start_solver
          @stdin.stub(:gets).and_return(code, "\n")
          stdout_should_receive("Invalid code: #{code}")
          @solver.input_piece.should == nil
        end
      end
    end
    
#    context 'inputing Game state as a codestring' do
#      it 'should ignore wrong piece codes' do
#        WRONG_CODES.each do |code|
#          start_solver
#          stdout_should_receive("Free:\n#{BYD}\n#{BYD}\n#{BYD}\nBoard:\n#{BYD}\n#{BYD}\n#{BYD}\n")
#          @solver.input_state(code+"\n"+"BYD\n"*6)
#        end
#      end
#      it 'should output matching Piece name' do
#        CODES.each do |code, name|
#          start_solver
#          stdout_should_include(name)
#          @solver.input_state("#{code}\n"+"BYD\n"*5)
#        end
#      end
#      it 'should raise exception if not enough Pieces' do
#        (0..5).each do |n| 
#          start_solver
#          lambda{@solver.input_state("BYD\n"*n)}.should raise_error(Invalid)
#        end  
#      end
#      it 'should output correct Game state' do
#        CODES.each do |code, name|
#            start_solver
#            stdout_should_receive("Free:\n#{name}\n#{BYD}\n#{BYD}\nBoard:\n#{BYD}\n#{BYD}\n#{BYD}\n")
#            @solver.input_state("#{code}\n#"+"BYD\n"*5)
#        end
#      end
#    end

    context 'inputing Game state from stdin' do
      it 'should report wrong piece codes' do
        WRONG_CODES.each do |code|
          start_solver(:input => ["BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", code+"\n", "\n"])
          stdout_should_receive("Invalid code: #{code}\n")
          @solver.input_state
        end
      end
      it 'should output matching Piece name' do
        CODES.each do |code, name|
          start_solver(:input => [code+"\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "\n"])
          stdout_should_include(name)
          @solver.input_state
        end
      end
      it 'should raise exception if not enough Pieces' do
        (0..5).each do |n| 
          start_solver(:input => [* Array.new(n,"BYD\n") << "\n"])
          lambda{@solver.input_state}.should raise_error(Invalid)
        end  
      end
      it 'should output prompts, separate piece feedback and then correct Game state' do
        CODES.each do |code, name|
          start_solver(:input => [code+"\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "\n"])
          stdout_should_receive("Enter Free Piece code (1):", "You entered Free Piece (1): #{name}", 
                                "Enter Free Piece code (2):", "You entered Free Piece (2): #{BYD}",
                                "Enter Free Piece code (3):", "You entered Free Piece (3): #{BYD}",
                                "Enter Board Piece code (1):", "You entered Board Piece (1): #{BYD}",
                                "Enter Board Piece code (2):", "You entered Board Piece (2): #{BYD}",
                                "Enter Board Piece code (3):", "You entered Board Piece (3): #{BYD}")
          @solver.input_state
        end
      end
    end
    
    context 'showing state/hints' do
      it 'should correctly output Game state before making move' do
        CODES.each do |code, name|
          start_solver(:input => [code+"\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "\n"])
          @solver.input_state
          stdout_should_receive("Free:\n#{name}\n#{BYD}\n#{BYD}\nBoard:\n#{BYD}\n#{BYD}\n#{BYD}\n")
          @solver.make_move
        end
      end
      
      it 'should output zero Rules when making moves in inconsistent (wrong) Game state' do
        start_solver(:generator => Turn1Generator.new, :input => ["BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "BYD\n", "\n"])
        stdout_should_include(/Rules\(0\):\s*Moves\(0\):/)
        @solver.input_state
        @solver.make_move
      end
      
      it 'should output possible game Rules wheh given correct Game state' do
        start_solver(:generator => Turn1Generator.new, :input => ["BGC\n", "sgd\n", "syc\n", "BYD\n", "SYD\n", "BGD\n", "\n"])
        stdout_should_include \
"Rules(2):
If last Piece is Any Piece, Diamond Piece is next
If last Piece is Any Piece, Same shape Piece is next
Moves(1):
Small Green Diamond(2)"
        @solver.input_state
        @solver.make_move
      end
    end
    
    context 'making move' do
      it 'should prompt to make move' do
        start_solver(:generator => Turn1Generator.new, :input => ["BGC\n", "sgd\n", "syc\n", "BYD\n", "SYD\n", "BGD\n", "\n"])
        stdout_should_include("Make your move:")
        @solver.input_state
        @solver.make_move
      end

      it 'should output move feedback for incorrect move (invalid code, interrupt)' do
        start_solver(:generator => Turn1Generator.new, :input => ["BGC\n", "sgd\n", "syc\n", "BYD\n", "SYD\n", "BGD\n", "\n"])
        @solver.input_state 
        @stdin.stub(:gets).and_return("Saa","\n","SYC","SYD","BYC")
        stdout_should_include("Make your move:", "Wrong move (no piece given)")
        @solver.make_move
      end

      it 'should output move feedback for incorrect move (valid code, but not in free set)' do
        start_solver(:generator => Turn1Generator.new, :input => ["BGC\n", "sgd\n", "syc\n", "BYD\n", "SYD\n", "BGD\n", "\n"])
        @solver.input_state 
        @stdin.stub(:gets).and_return("BGD","N","SYC","SYD","BYC")
        stdout_should_include("Make your move:", "Wrong move (not in free set): Big Green Diamond")
        @solver.make_move
      end

      it 'should output move feedback for right move' do
        start_solver(:generator => Turn1Generator.new, :input => ["BGC\n", "sgd\n", "syc\n", "BYD\n", "SYD\n", "BGD\n", "\n"])
        @solver.input_state 
        @stdin.stub(:gets).and_return("SGD","Y","SYC","SYD","BYC")
        stdout_should_include("Make your move:", "You moved: Small Green Diamond", "Was the move right(Y/N)?:", "Great, now enter new Free set:")
        @solver.make_move
      end

      it 'should output move feedback for wrong move' do
        start_solver(:generator => Turn1Generator.new, :input => ["BGC\n", "sgd\n", "syc\n", "BYD\n", "SYD\n", "BGD\n", "\n"])
        @solver.input_state 
        @stdin.stub(:gets).and_return("SYC","N")
        stdout_should_include("Make your move:", "You moved: Small Yellow Circle", "Was the move right(Y/N)?:", "Too bad")
        @solver.make_move
      end
    end
  end
end
