require "sinatra"
require 'pry'

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def starting_scores
    session[:player_score] = 0
    session[:computer_score] = 0
end

def computer_pick
  choices = ["r", "p", "s"]
  choices.sample
end

def match_win(player, computer)
  if player == computer
    "tie"
  elsif (player == "Rock" && computer == "s") || (player == "Paper" && computer == "r") || (player == "Scissors" && computer == "p")
    "player"
  elsif (computer == "r" && player == "Scissors") || (computer == "p" && player == "Rock") || (computer == "s" && player == "Paper")
    "computer"
  end
end

def gameplay_messages(winner)
  until session[:player_score] == 2 || session[:computer_score] == 2
    if winner == "tie"
      "Tie. Choose again."
    elsif winner == "computer"
      "Computer wins this round!"
      session[:computer_score] += 1
    else
      "You won this round!"
      session[:player_score] += 1
    end
  redirect '/'
  end
end

def game_winner
  if session[:player_score] > session[:computer_score]
    "player"
  else
    "computer"
  end
end

get '/' do
  if session[:player_score].nil? && session[:computer_score].nil?
    starting_scores
  end

  erb :form, locals: { player_score: session[:player_score], computer_score: session[:computer_score] }
end

post '/' do
  winner = match_win(params["player_choice"], computer_pick)
  gameplay_messages(winner)
  game_winner
  starting_scores
  redirect '/'
end
