Feature: Gamer inputs Game state

    In order to get help with specific Elus game, 
	as Gamer, I want to input Game state

	Description: Gamer enters 3-char sequences representing 3 free Pieces. 
	If the Game just started, he is then prompted for 3 3-char sequences representing Pieces already on the Board.
	
	Pieces have 3 characteristics: Size: BIG/SMALL, Color: YELLOW/GREEN, Type: DIAMOND/CIRCLE
	Gamer's input will be in a form BYR, SGC, etc
	
	Scenario: every correct code results in correct feedback / game state
		Given new Game just started
		When I run solver 2,000 times and use 6 correct codes to input state
		Then I should see all the correct feedback, piece names and game states

	Scenario Outline: every correct code results in correct feedback and game state
		Given new Game just started
		When I input code <code> 
		Then I should see "You entered Free Piece (1): <piece>"
		
		Examples: Big Yellow Diamond
			| code | piece               |
			| BYR  | Big Yellow Diamond  |
			| BYD  | Big Yellow Diamond  |
			| bYR  | Big Yellow Diamond  |
			| ByR  | Big Yellow Diamond  |
			| BYr  | Big Yellow Diamond  |
			| byR  | Big Yellow Diamond  |
			| bYr  | Big Yellow Diamond  |
			| byr  | Big Yellow Diamond  |
			| byd  | Big Yellow Diamond  |
			| 111  | Big Yellow Diamond  |
			| bdy  | Big Yellow Diamond  |
			| dyb  | Big Yellow Diamond  |
			| d y b | Big Yellow Diamond |
			| dby  | Big Yellow Diamond  |
			| ybd  | Big Yellow Diamond  |
			| ddddyb | Big Yellow Diamond |
			| dyybb | Big Yellow Diamond  |
			| dxbyxd | Big Yellow Diamond |
			| by1  | Big Yellow Diamond  |
			
		Examples: Small Yellow Diamond
			| code | piece               |
			| SYR  | Small Yellow Diamond|
			| SYD  | Small Yellow Diamond|
			| syr  | Small Yellow Diamond|
			| syd  | Small Yellow Diamond|
			| 011  | Small Yellow Diamond|
			| dys  | Small Yellow Diamond|

		Examples: Big Green Diamond
			| code | piece               |
			| BGR  | Big Green Diamond   |
			| BGD  | Big Green Diamond   |
			| bgr  | Big Green Diamond   |
			| bgd  | Big Green Diamond   |
			| BgR  | Big Green Diamond   |
			| 101  | Big Green Diamond   |

		Examples: Small Green Diamond
			| code | piece               |
			| SGR  | Small Green Diamond |
			| SGD  | Small Green Diamond |
			| sgd  | Small Green Diamond |
			| 001  | Small Green Diamond |

		Examples: Big Yellow Circle
			| code | piece               |
			| BYC  | Big Yellow Circle   |
			| byc  | Big Yellow Circle   |
			| byC  | Big Yellow Circle   |
			| bYC  | Big Yellow Circle   |
			| bYc  | Big Yellow Circle   |
			| Byc  | Big Yellow Circle   |
			| ByC  | Big Yellow Circle   |
			| BYC  | Big Yellow Circle   |
			| BYc  | Big Yellow Circle   |
			| 110  | Big Yellow Circle   |

		Examples: Small Yellow Diamond
			| code | piece               |
			| SYC  | Small Yellow Circle |
			| syc  | Small Yellow Circle |
			| 010  | Small Yellow Circle |

		Examples: Big Green Circle
			| code | piece               |
			| BGC  | Big Green Circle    |
			| bgc  | Big Green Circle    |
			| 100  | Big Green Circle    |

		Examples: Small Green Circle
			| code | piece               |
			| SGC  | Small Green Circle  |
			| sgc  | Small Green Circle  |
			| 000  | Small Green Circle  |

	Scenario Outline: wrong codes results in error message
		Given new Game just started
		When I input code <code> 
		Then I should see "Invalid code: <code>"
		
		Examples: Ambiguous codes
			| code |
			| BSYR  |
			| BYgD  |
			| bYRc  |
			| Bydc  |
			| BsYgr  |
			| bygRc  |
			| bsYrc  |
			| bsygcr |

		Examples: Not enough meaningful codes
			| code |
			| _   |
			| !@# |
			| B   |
			| gb  |
			| gr  |
			| sca |
			| bgt |
			| thd |

		Examples: Numeric code errors (not enough, too much, wrong numbers)
			| code |
			| 0   |
			| 1   |
			| 01  |
			| 11  |
			| 1111  |
			| 112  |
			| 101231|
