require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )

module Elus
  include ElusTest
  
  shared_examples_for 'all generators' do
    it 'should generate rules array' do
      generator = described_class.new
      rules = generator.generate_rules
      rules.class.should == Array
      rules.each {|rule| rule.class.should == Rule} unless rules.empty?
    end
  end
  
  describe Generator do
    it_should_behave_like 'all generators' 
  end

  describe EmptyGenerator do
    it_should_behave_like 'all generators' 

    it 'should generate empty rules set' do
      generator = EmptyGenerator.new
      generator.generate_rules.should == []
    end
  end

  describe Turn1Generator do
    before :each do
      @generator = Turn1Generator.new
      @rules = @generator.generate_rules
    end
    
    it_should_behave_like 'all generators' 

    it 'should generate non-empty rules set' do
      @rules.should_not be_empty
    end

    it 'should generate rules with Any condition and without "no" branch' do
      @rules.each do |rule|
        rule.name.should =~ /If last Piece is Any Piece/
        rule.name.should_not =~ /otherwise/
      end
    end

    it 'should generate only rules with valid(.X.) Pieces in "yes" branch' do
      @rules.count.should == 12
      permutate do |code|
        piece = Piece.create(code)
        re = Regexp.new(', ' + piece.name + ' Piece is next')
        @rules.count {|rule| rule.name =~ re}.should == 1
      end
    end
  end

  describe Turn2Generator do
    before :each do
      @generator = Turn2Generator.new
      @rules = @generator.generate_rules
    end
    
    it_should_behave_like 'all generators' 

    it 'should generate non-empty rules set' do
      @rules.should_not be_empty
    end

    it 'should generate rules without Any condition and with obligatory "no" branch' do
      @rules.each do |rule|
        rule.name.should_not =~ /If last Piece is Any Piece/
        rule.name.should =~ /otherwise/
      end
    end

    it 'should generate only rules with opposite yes-no branches' do
      @rules.count.should == 36
      permutate('1') do |cond_code|
        cond = Piece.create(cond_code)
        permutate do |yes_code|
          yes = Piece.create(yes_code)
          no = Piece.create(Piece.different(yes_code))
          re = Regexp.new("If last Piece is #{cond.name} Piece, #{yes.name} Piece is next, otherwise #{no.name} Piece is next")
          @rules.count {|rule| rule.name =~ re}.should == 1
        end
      end
    end
  end

  describe Turn3Generator do
    before :each do
      @generator = Turn3Generator.new
      @rules = @generator.generate_rules
    end
    
    it_should_behave_like 'all generators' 

    it 'should generate non-empty rules set' do
      @rules.should_not be_empty
    end

    it 'should generate rules without Any condition and with obligatory "no" branch' do
      @rules.each do |rule|
        rule.name.should_not =~ /If last Piece is Any Piece/
        rule.name.should =~ /otherwise/
      end
    end

    it 'should generate rules with all possible yes-no branches' do
      @rules.count.should == 432
      permutate('1') do |cond_code|
        cond = Piece.create(cond_code)
        permutate do |yes_code|
          yes = Piece.create(yes_code)
          permutate do |no_code|
            no = Piece.create(no_code)
            re = Regexp.new("If last Piece is #{cond.name} Piece, #{yes.name} Piece is next, otherwise #{no.name} Piece is next")
            @rules.count {|rule| rule.name =~ re}.should == 1
          end
        end
      end
    end
  end
end