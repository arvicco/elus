Feature: Gamer starts Solver

	In order to win multiple Elus games, 
	as Gamer, I want to start Solver
	
	Description: Gamer opens up a shell, types a command, and sees a welcome message and a prompt to input Game state.

	Scenario: start Solver
		Given I have not started yet
		When I start Solver
		Then I should see "Welcome to Elus Solver!"
		And I should see "Enter Game state:"
		