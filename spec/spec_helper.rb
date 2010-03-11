$LOAD_PATH << File.join(File.dirname(__FILE__),".." ,"lib" )

#require 'rubygems'
#require 'spec'
require 'elus'

module ElusTest
  PIECE_CHARS = '01=!.'
  NONDOT_CHARS = '01!='
  
  def random_chars_twice(n=1, string=PIECE_CHARS)
    chars = string.split(//)
    n.times { yield chars.sample(3).join(''), chars.sample(3).join('') }
  end

  def all_chars(string=PIECE_CHARS)
    chars = string.split(//)
    chars.product(chars,chars).each {|code_chars| yield code_chars.join('') }
  end
  
  def all_chars_twice(string1=PIECE_CHARS, string2=string1)
    all_chars(string1) {|code1| all_chars(string2) {|code2| yield code1, code2 } }
  end

  def permutate(string=NONDOT_CHARS)
    string.split(//).product(['.'],['.']).each do |set|
      set.permutation.to_a.uniq.each do |code_chars|
        yield code_chars.join('')
      end
    end
  end

  def should_be_equal(p1, p2)
    (p1 == p2).should be_true
    (p1 >= p2).should be_true
    (p1 <= p2).should be_true
    (p1 > p2).should be_false
    (p1 < p2).should be_false
  end
  


  BYD = 'Big Yellow Diamond'
  WRONG_RULES = [
    ["B", 'BY', 'BSYC'], 
    ['BYG', 'BYCD'], 
    ['BGX', 'ZXC', 1],
    ['ZXAQWET1234567890', ''],
    [1, 2],
    [1, 2, 3],
    ['...', '..1', 3]
    ]
  RULES = {
    ['...', '.!.'] => 'If last Piece is Any Piece, Different color Piece is next',
    ['...', '..='] => 'If last Piece is Any Piece, Same shape Piece is next', 
    ['...', '1..'] => 'If last Piece is Any Piece, Big Piece is next', 
    ['...', '.!1'] => 'If last Piece is Any Piece, Different color Diamond Piece is next',
    ['..1', '1..', '0..'] => 'If last Piece is Diamond Piece, Big Piece is next, otherwise Small Piece is next', 
    ['1..', '.0.', '.1.'] => 'If last Piece is Big Piece, Green Piece is next, otherwise Yellow Piece is next',
    ['..1', '=..', '!..'] => 'If last Piece is Diamond Piece, Same size Piece is next, otherwise Different size Piece is next',
    ['.1.', '..!', '0..'] => 'If last Piece is Yellow Piece, Different shape Piece is next, otherwise Small Piece is next'
    }


  WRONG_CODES = ["B", 'BY', 'BSYC', 'BYG', 'BYCD', 'BGX', 'ZXC', 'ZXAQWET1234567890', " "] 

  SPECIAL_CODES = {
        '...' => 'Any',
        '1..' => 'Big',
        '0..' => 'Small',
        '.1.' => 'Yellow',
        '.0.' => 'Green',
        '..1' => 'Diamond',
        '..0' => 'Circle',
        '11.' => 'Big Yellow',
        '10.' => 'Big Green',
        '01.' => 'Small Yellow',
        '00.' => 'Small Green',
        '1.1' => 'Big Diamond',
        '1.0' => 'Big Circle',
        '0.1' => 'Small Diamond',
        '0.0' => 'Small Circle',
        '.11' => 'Yellow Diamond',
        '.10' => 'Yellow Circle',
        '.01' => 'Green Diamond',
        '.00' => 'Green Circle',
        '!..' => 'Different size',
        '=..' => 'Same size',
        '.!.' => 'Different color',
        '.=.' => 'Same color',
        '..!' => 'Different shape',
        '..=' => 'Same shape',
        '!!.' => 'Different size Different color',
        '!=.' => 'Different size Same color',
        '=!.' => 'Same size Different color',
        '==.' => 'Same size Same color',
        '!.!' => 'Different size Different shape',
        '!.=' => 'Different size Same shape',
        '=.!' => 'Same size Different shape',
        '=.=' => 'Same size Same shape',
        '.!!' => 'Different color Different shape',
        '.!=' => 'Different color Same shape',
        '.=!' => 'Same color Different shape',
        '.==' => 'Same color Same shape',
        '!!1' => 'Different size Different color Diamond',
        '!=1' => 'Different size Same color Diamond',
        '=!1' => 'Same size Different color Diamond',
        '==1' => 'Same size Same color Diamond',
        '!1!' => 'Different size Yellow Different shape',
        '!1=' => 'Different size Yellow Same shape',
        '=1!' => 'Same size Yellow Different shape',
        '=1=' => 'Same size Yellow Same shape',
        '1!!' => 'Big Different color Different shape',
        '1!=' => 'Big Different color Same shape',
        '1=!' => 'Big Same color Different shape',
        '1==' => 'Big Same color Same shape',
        '!!0' => 'Different size Different color Circle',
        '!=0' => 'Different size Same color Circle',
        '=!0' => 'Same size Different color Circle',
        '==0' => 'Same size Same color Circle',
        '!0!' => 'Different size Green Different shape',
        '!0=' => 'Different size Green Same shape',
        '=0!' => 'Same size Green Different shape',
        '=0=' => 'Same size Green Same shape',
        '0!!' => 'Small Different color Different shape',
        '0!=' => 'Small Different color Same shape',
        '0=!' => 'Small Same color Different shape',
        '0==' => 'Small Same color Same shape',
        '!!!' => 'All Different',
        '===' => 'All Same',
        'B!0' => 'Big Different color Circle',
        '!g0' => 'Different size Green Circle',
        '0!0' => 'Small Different color Circle',
        '=10' => 'Same size Yellow Circle',
        '!0d' => 'Different size Green Diamond',
        '!00' => 'Different size Green Circle',
        '=01' => 'Same size Green Diamond',
        '=gc' => 'Same size Green Circle',
        '0y!' => 'Small Yellow Different shape',
        '00=' => 'Small Green Same shape',
        '0Y!' => 'Small Yellow Different shape',
        's1=' => 'Small Yellow Same shape',
        }
  CODES = {
   "BYR"=>BYD,
   "BYD"=>BYD,
   "bYR"=>BYD,
   "ByR"=>BYD,
   "BYr"=>BYD,
   "byR"=>BYD,
   "bYr"=>BYD,
   "byr"=>BYD,
   "byd"=>BYD,
   "111"=>BYD,
   "bdy"=>BYD,
   "B YD"=>BYD,
   "dyb"=>BYD,
   "bY R"=>BYD,
   "B y R"=>BYD,
   " b y R "=>BYD,
   "bYr "=>BYD,
   " byr"=>BYD,
   "1 1 1"=>BYD,
   "SYR"=>"Small Yellow Diamond",
   "SYD"=>"Small Yellow Diamond",
   "syr"=>"Small Yellow Diamond",
   "syd"=>"Small Yellow Diamond",
   "011"=>"Small Yellow Diamond",
   "dys"=>"Small Yellow Diamond",
   "BGR"=>"Big Green Diamond",
   "BGD"=>"Big Green Diamond",
   "bgr"=>"Big Green Diamond",
   "bgd"=>"Big Green Diamond",
   "BgR"=>"Big Green Diamond",
   "101"=>"Big Green Diamond",
   "SGR"=>"Small Green Diamond",
   "SGD"=>"Small Green Diamond",
   "sgd"=>"Small Green Diamond",
   "001"=>"Small Green Diamond",
   "BYC"=>"Big Yellow Circle",
   "byc"=>"Big Yellow Circle",
   "byC"=>"Big Yellow Circle",
   "bYC"=>"Big Yellow Circle",
   "bYc"=>"Big Yellow Circle",
   "Byc"=>"Big Yellow Circle",
   "ByC"=>"Big Yellow Circle",
   "BYc"=>"Big Yellow Circle",
   "110"=>"Big Yellow Circle",
   "SYC"=>"Small Yellow Circle",
   "syc"=>"Small Yellow Circle",
   "010"=>"Small Yellow Circle",
   "BGC"=>"Big Green Circle",
   "bgc"=>"Big Green Circle",
   "100"=>"Big Green Circle",
   "SGC"=>"Small Green Circle",
   "sgc"=>"Small Green Circle",
   "000"=>"Small Green Circle" }
end