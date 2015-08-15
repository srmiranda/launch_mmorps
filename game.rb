# YOUR CODE GOES HERE
computer = 0
player   = 0
choices  = {"r" => "rock", "p" => "paper", "s" => "scissors"}

while computer < 2 && player < 2
  puts "Player Score: #{player}, Computer Score: #{computer}"
  puts "Choose rock (r), paper (p), or scissors (s): "
  input = gets.chomp.downcase
  if !choices.include?(input)
    puts "Invalid response."
    puts ""
    redo
  end
  puts "Player chose #{choices[input]}."

  comp_choice = ["r", "p", "s"].sample
  puts "Computer chose #{choices[comp_choice]}."

  # Calculations for what beats what
  if (input == "r" && comp_choice == "s") || (input == "p" && comp_choice == "r") || (input == "s" && comp_choice == "p")
    player += 1
    puts "#{choices[input].capitalize} beats #{choices[comp_choice]}. Player wins the round."
  elsif (comp_choice == "r" && input == "s") || (comp_choice == "p" && input == "r") || (comp_choice == "s" && input == "p")
    computer += 1
    puts "#{choices[comp_choice].capitalize} beats #{choices[input]}. Computer wins the round."
  else
    puts "Tie. Choose again."
  end
  puts ""
end

(computer == 2) ? (puts "Computer wins!") : (puts "Player wins!")
