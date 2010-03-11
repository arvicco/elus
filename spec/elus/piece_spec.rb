require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )

module Elus
  include ElusTest

  describe Piece do
    context "creating" do
      it "should raise error if new method is called" do
        CODES.each_key do |code|
          lambda{Piece.new(code)}.should raise_error(NoMethodError)
        end
        WRONG_CODES.each do |code|
          lambda{Piece.new(code)}.should raise_error(NoMethodError)
        end
      end

      it "should return nil for a wrong code" do
        WRONG_CODES.each do |code|
          Piece.create(code).should == nil
        end  
        Piece.create(nil).should == nil
        Piece.create('').should == nil
        Piece.create(1).should == nil
        Piece.create(3.14).should == nil
        Piece.create(:byd).should == nil
        Piece.create([]).should == nil
        Piece.create([1,2,3]).should == nil
        Piece.create({:symb=>'something'}).should == nil
      end  
      
      it "should have code and name consistent with an input code" do
        CODES.each do |code, name|
          Piece.create(code).name.should == name
          Piece.create(code).code.should == Piece.convert_code(code)
        end
      end
      
      it "should drop irrelevant characters from code" do
        Piece.create('b y d ').name.should == BYD
        Piece.create('yfdzb').name.should == BYD
        Piece.create('AEFHIJKLMNOPQTUVWXZaefhijklmnopqtuvwxz byd').name.should == BYD
        Piece.create('byd23456789~@#$%^&*()_+-?><{}[],|/`').name.should == BYD
      end
      
      it "should drop duplicate characters from code" do
        Piece.create('byyd').name.should == BYD
        Piece.create('DDyb').name.should == BYD
        Piece.create('AEFHIJbbbbbbbbbbbbbbbbbbbbyd').name.should == BYD
        Piece.create('byddd').name.should == BYD
        Piece.create('byrd').name.should == BYD
        Piece.create('bydrrdrrrrdr').name.should == BYD
      end
      
      it "should sort code letter if they are given in wrong order" do
        Piece.create('ydb').name.should == BYD
        Piece.create('ybd').name.should == BYD
        Piece.create('dBy').name.should == BYD
        Piece.create('Dby').name.should == BYD
        Piece.create('dyb').name.should == BYD
        Piece.create('Bdy').name.should == BYD
      end
      
      it "should not sort code letter mixed with numbers or specials but return nil" do
        Piece.create('1dy').should == nil
        Piece.create('d1b').should == nil
        Piece.create('yb0').should == nil
        Piece.create('!dy').should == nil
        Piece.create('d=b').should == nil
        Piece.create('yb.').should == nil
      end
      
      it "should create Pieces from codes with special meaning" do
        SPECIAL_CODES.each do |code, name|
          Piece.create(code).name.should == name
        end
      end
    end
  
    context 'comparing' do
      it 'should match its code, self and Piece with the same code' do
       (CODES.merge SPECIAL_CODES).each do |code, name|
          piece1 = Piece.create(code)
          piece2 = Piece.create(code)
          should_be_equal(piece1, code)
          should_be_equal(piece1, piece1)
          should_be_equal(piece1, piece2)
        end
      end
      
      it 'should be reciprocal' do
       all_chars_twice do |code1, code2|
          piece1 = Piece.create(code1)
          piece2 = Piece.create(code2)
          should_be_equal(piece2, piece1) if piece1 == piece2
          should_be_equal(piece1, piece2)  if piece2 == piece1
        end
      end
      
      it 'should match dots in all positions' do
        all_chars do |code|
          c1,c2,c3 = code.split(//)
          piece = Piece.create(c1+c2+c3)
           should_be_equal(piece, '.'+c2+c3)
           should_be_equal(piece,  Piece.create('.'+c2+c3))
           should_be_equal(Piece.create('.'+c2+c3),  piece)
           should_be_equal(piece,  c1+'.'+c3)
           should_be_equal(piece,  Piece.create(c1+'.'+c3))
           should_be_equal(Piece.create(c1+'.'+c3),  piece)
           should_be_equal(piece,  c1+c2+'.')
           should_be_equal(piece,  Piece.create(c1+c2+'.'))
           should_be_equal(Piece.create(c1+c2+'.'),  piece)
       end
      end
      it 'should support eql? comparison (based on code)' do
       all_chars_twice do |code1, code2|
          piece1 = Piece.create(code1)
          piece2 = Piece.create(code2)
          (piece1.eql? piece2).should be_true if piece1.code == piece2.code
          (piece2.eql? piece1).should be_true if piece1.code == piece2.code
        end
      end

      it "should be bigger than nil" do
       all_chars('01=!.') do |code|
       (Piece.create(code) > nil).should be_true
        end
      end
    end
    
    context 'multiplying Piece by mask (finding next Piece)' do
      it 'should copy mask if the mask contains only numbers OR dots' do
        all_chars_twice('01.=!', '01.') do |code1, code2|
            piece = Piece.create(code1)
            mask = Piece.create(code2)
            should_be_equal(piece * mask, mask)
        end  
      end
  
      it 'should convert mask if mask contains special chars' do
        all_chars_twice do |orig_code, mask_code|  
          expected = []
          mask_code.split(//).each_with_index do |char,i|
            expected[i] = case char
                            when '0' then '0'
                            when '1' then '1'
                            when '.' then '.'
                            when '=' then orig_code[i]
                            when '!' then Piece.different(orig_code[i])
                          end
          end
            expected_code = expected.join('')
            piece = Piece.create(orig_code)
            mask = Piece.create(mask_code)
            should_be_equal(piece * mask, expected_code)
            should_be_equal(piece * mask, Piece.create(expected_code))
        end
      end
    end

    context 'assorted class methods' do
      it 'should be able to return universal (Any) Piece' do
        any = Piece.any
        any.name.should == 'Any'
        all_chars do |code|
          piece = Piece.create(code)
          should_be_equal(piece, any)
          (piece * any).name.should == 'Any'
        end
      end
  
      it 'should be able to convert code to different (opposite)' do
        all_chars do |code|  
          expected = []
          code.split(//).each_with_index do |char,i|
            expected[i] = case char
                            when '0' then '1'
                            when '1' then '0'
                            when '.' then '.'
                            when '=' then '!'
                            when '!' then '='
                          end
          end
          expected_code = expected.join('')
          Piece.different(code).should == expected_code
        end
      end
    end

  end
end
