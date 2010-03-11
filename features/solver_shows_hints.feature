Feature: Solver shows hints

	In order to get some help with Elus game
	as Gamer, I want the Solver to show hints
	
	Description: Once the Gamer inputs/updates valid Elus Game state, 
	Solver tries to figure out WHAT Rules may be possible under current Game state,
	produces hints regarding possible rules and next moves by the Gamer and displays hints to the Gamer.

	Scenario Outline: Solver shows hints after initial Game state input
		Given Elus Game state is <state> 
		And Game started with <generator> 
		When I input Game state and prepare to move
		Then I should see "<moves>"
		And I should see "<rules>"
	
		Examples: Invalid Game states: 
			| generator      | state                   | moves | rules |
			| EmptyGenerator | BYD BYD BYD BYD BYD BYD | Moves(0): | Rules(0): |
			| Turn1Generator | BYD BYD BYD BYD BYD BYD | Moves(0): | Rules(0): |
			| Turn2Generator | BYD BYD BYD BYD BYD BYD | Moves(0): | Rules(0): |
			| Turn3Generator | BYD BYD BYD BYD BYD BYD | Moves(0): | Rules(0): |

		Examples: Valid Game states: 
			| generator      | state                   | moves | rules |
			| Turn1Generator | BGC sgd syc BYD SYD BGD | Moves(1): | Rules(2): |

	Scenario Outline: Solver shows hints after Gamer makes his move state input
		Given Elus Game state is <code1>,<code2>,<code3>,<code4>,<code5>,<code6> 
		And Game started with <generator> 
		And initial Game state was already input
		When I move this <piece>
		Then I should see "<moves>"
		And I should see "<rules>"
			
			