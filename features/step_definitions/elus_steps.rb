def stdout
  @stdout ||= StringIO.new # STDOUT is an instance of IO. The StringIO object is very much like an IO object.
end

def stdin(input=nil)
  @stdin ||= StringIO.new # STDIN is an instance of IO. The StringIO object is very much like an IO object.
  @stdin.reopen input if input
  @stdin
end

def solver
  @solver ||= Elus::Solver.new(stdin, stdout) # Elus::Solver expects STDOUT, but we're giving it our StringIO @stdout instead
end

def solver_restart_and_input(input_codes) 
  @stdin = StringIO.new
  @stdout = StringIO.new
  stdin input_codes.join("\n")+"\n\n"
  @solver = Elus::Solver.new(stdin, stdout)
  solver.start generator
  solver.input_state
end

def generator
  @generator ||= stub('generator', :generate_rules => [])
end
  
def fixnum_from(string)
  string.scan(/\d/).join.to_i
end

def messages_should_include(message)
  @stdout.string.split("\n" ).should include(message)
end

def messages_include?(message)
  @stdout.string.split("\n").include?(message)
end

def outputs_count(string, options={})
  pattern = Regexp.new(options[:regex]? string : Regexp.escape(string))
  @stdout.string.scan(pattern).size
end

def outputs_count_should_be_correct_for input_codes
  # For each unique name corresponding to one of the input_codes
  input_codes.map {|code| @code_names[code]}.uniq.each do |name| 
    repeats = input_codes.count {|code| @code_names[code]==name}
    name_feedback = Regexp.escape('You entered ') + '.*' + Regexp.escape(": #{name}")
    outputs_count(name_feedback, :regex => true).should == repeats
  end
end

Given /^I have not started yet$/ do
end

When /^I start Solver$/ do
  solver.start generator
end

Then /^I should see "([^\"]*)"$/ do |message|
  messages_should_include(message)
end

Given /^new Game just started$/ do
  solver.start generator
end

When /^I input code (.*)$/ do |code|
  stdin "#{code}\n"+"BYR\n"*6+"\n"
  solver.input_state
end

When /^I run solver (.*) times and use (.*) correct codes to input state/ do |times, num_codes|
  @times = fixnum_from(times)
  @num_codes = fixnum_from(num_codes)
  @code_names = ElusTest::CODES
end

Then /^I should see all the correct feedback, piece names and game states$/ do
   @times.times do
      #@code_names.keys.combination(@num_codes) do |input_codes|  # Takes too long to complete!
      input_codes = Array.new(@num_codes) {|i| @code_names.keys[rand(@code_names.size)]}
      solver_restart_and_input input_codes
      
      outputs_count_should_be_correct_for input_codes
#      outputs_count('Free:').should == 1
#      outputs_count('Board:').should == 1
  end    
  
end

Given /^Elus Game state is (.*)$/ do |state|
  stdin state.split(' ').join("\n")+"\n\n"
end

Given /^Game started with (.*)$/ do |gen_type|
  Generator = Elus.const_get gen_type
  solver.start Generator.new
end

When /^I input Game state and prepare to move$/ do
  solver.input_state
  @stdin.reopen "\n\n" # Inputing zero code for first move
  solver.make_move
end

Given /^Game state inputed$/ do
  solver.input_state
end

When /^I move (.*)$/ do |piece|
  @stdin.reopen(piece+"\nY\nSYC\nSYD\nBYC\n")
  solver.make_move
end

