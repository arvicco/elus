require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )

module Elus
  include ElusTest

  describe Rule do
    context 'creating' do
      it 'should create appropriate Rules given correct arguments' do
        RULES.each do |args, name|
          rule = Rule.new(*args)
          rule.name.should == name
        end
      end
      it 'should fail if given wrong arguments' do
        WRONG_RULES.each do |args|
          lambda{Rule.new(*args)}.should raise_error(Invalid)
        end
      end
    end
    context 'applying Rule to Pieces' do
      it 'should produce expected outcome when applied to any Piece' do
        all_chars_twice('01.') do |piece, condition|
          p =  Piece.create(piece)
          c =  Piece.create(condition)
          random_chars_twice 100 do |yes, no|
            y =  Piece.create(yes)
            n =  Piece.create(no)
            rule = Rule.new(c, y, n)
            if p == c
              should_be_equal(rule.apply(p), p * y)
            else  
              should_be_equal(rule.apply(p), p * n)
            end
          end
        end
      end
    end
  end
end
