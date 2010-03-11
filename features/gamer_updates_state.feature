Feature: Gamer updates state

    In order to get relevant help as the Elus game progress,
    as Gamer, I want to update Game state, making moves and reporting its results

	Description: In response to "Please make your move:" prompt, Gamer enters 3-char code of the
	Piece he is going to move (it should be one of 3 free Pieces). Gamer then gets feedback
	either confirming the move or error message and prompt for the correct move. Once the move
	is confirmed, Gamer is asked for move result (was the move right or wrong) and a new set of
	free Game pieces if the result was right.
	
	Scenario Outline: Gamer makes moves
		Given Elus Game state is <state>
		And Game started with <generator>
		And Game state inputed
		When I move <piece>
		Then I should see "<feedback>"
		And I should see "<next prompt>"
		
		Examples: 
			| state 	              | generator      | piece | feedback                                           | next prompt		      |
			| BGC sgd syc BYD SYD BGD | Turn1Generator | SGD   | You moved: Small Green Diamond                     | Was the move right(Y/N)?:|
			| BGC sgd syc BYD SYD BGD | Turn1Generator | BGC   | You moved: Big Green Circle                        | Was the move right(Y/N)?:|
			| BGC sgd syc BYD SYD BGD | Turn1Generator | SYC   | You moved: Small Yellow Circle                     | Was the move right(Y/N)?:|
			| BGC sgd syc BYD SYD BGD | Turn1Generator |       | Wrong move (no piece given)                        | Make your move:   |
			| BGC sgd syc BYD SYD BGD | Turn1Generator | SYD   | Wrong move (not in free set): Small Yellow Diamond | Make your move:   |
	