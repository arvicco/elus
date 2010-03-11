module Elus
  class Piece
    # These constants are used for translating between the external string representation of a Game and the internal representation.
    VALID = "01sbgycdr=!."                    # Valid (meaningful) chars in code string (downcase)
    SORT = "01stghcdd=!."                     # Special unique chars good for sorting (B)ig->(T)itanic, (Y)ellow->(H)ellow, (R)hombus->(D)iamond
    FINAL = "010101011=!."                    # Final (place-dependent) representation as 0/1 digits
    INVALID = Regexp.new "[^#{VALID}]"        # Regexp matching all non-valid chars
    PATTERN = /^[01st=!.][01gh=!.][01cd=!.]$/ # Correct code pattern for Piece creation
    # Names for Piece characteristics (based on code)
    NAMES = [ {'0'=>'Small', '1'=>'Big', '='=>'Same size', '!'=>'Different size'},
    {'0'=>'Green', '1'=>'Yellow', '='=>'Same color', '!'=>'Different color'},
    {'0'=>'Circle', '1'=>'Diamond', '='=>'Same shape', '!'=>'Different shape'}  ]
    
    attr_reader :code
    private_class_method :new
    
    # Factory method: takes an input string and tries to convert it into valid Piece code. Returns new Piece if successful, otherwise nil
    def Piece.create(input)
      return nil unless String === input
      if input_code = convert_code(input) then new(input_code) else nil end 
    end
    
    # Pre-processes string into valid code for Piece creation
    def Piece.convert_code(input)
      # Remove all invalid chars from input and transcode it into sort chars
      input_code = input.downcase.gsub(INVALID, '').tr(VALID, SORT)
      # Remove dupes and sort unless code contains digits or special chars (place-dependent)
      input_code = input_code.scan(/\w/).uniq.sort.reverse.join unless input_code =~ /[01!=.]/ 
      # Translate sort chars into final chars
      input_code.tr!(SORT, FINAL) if input_code =~ PATTERN 
    end
 
   # Finds different (opposite, complimentary) code character
    def Piece.different(string)
      string.tr('01!=.', '10=!.')
    end  
 
   # Returns Any Piece (should be a singleton object)
    def Piece.any
      @@any ||= Piece.create('...')  
    end  

    # Assumes valid code (should be pre-filtered by Piece.create)
    def initialize(input_code)
      @code = input_code
    end
    
    # Returns full text name of this Piece
    def name
     (0..2).map {|i| NAMES[i][@code[i]]}.compact.join(' ').
      gsub(Regexp.new('^$'), 'Any').
      gsub(Regexp.new('Same size Same color Same shape'), 'All Same').
      gsub(Regexp.new('Different size Different color Different shape'), 'All Different')
    end
    
    def to_s; name end
    
    def * (other)
      new_code = case other
              when nil then nil
              when String then self * Piece.create(other)
              when Piece then
               (0..2).map do |i| 
                case other.code[i]
                  when '=' then code[i]
                  when '!' then Piece.different code[i]
                else other.code[i]
                end
              end.join
            else raise(ArgumentError, 'Piece compared with a wrong type')
            end
      Piece.create(new_code)
    end
    
    include Comparable
    
    def <=> (other)
      case other
        when nil then 1
        when String then self <=> Piece.create(other)
        when Piece then
        return 0 if code == other.code
        return 0 if code =~ Regexp.new(other.code)
        return 0 if other.code =~ Regexp.new(code)
      else raise(ArgumentError, 'Piece compared with a wrong type')
      end
    end
    
    def eql? (other)
      (Piece === other) ? @code.eql?(other.code) : false
    end
  end
end  
