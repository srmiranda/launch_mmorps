require "sinatra"
require 'pry'
require "sinatra/flash"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def starting_scores
    session[:player_score] = 0
    session[:computer_score] = 0
end

def computer_pick
  choices = ["Rock", "Paper", "Scissors"]
  choices.sample
end

def score
  until session[:player_score] == 2 || session[:computer_score] == 2
    if (session[:player_choice] == "Rock" && session[:computer_pick] == "Scissors") || (session[:player_choice] == "Paper" && session[:computer_pick] == "Rock") || (session[:player_choice] == "Scissors" && session[:computer_pick] == "Paper")
      session[:player_score] += 1
      flash[:message] = "Player won."
    elsif (session[:computer_pick] == "Rock" && session[:player_choice] == "Scissors") || (session[:computer_pick] == "Paper" && session[:player_choice] == "Rock") || (session[:computer_pick] == "Scissors" && session[:player_choice] == "Paper")
      session[:computer_score] += 1
      flash[:message] = "Computer won."
    elsif (session[:computer_pick] == session[:player_choice])
      flash[:message] = "Tie, choose again."
    end
  redirect "/"
 end
end

def game_winner
  if session[:player_score] >= 2
    "Player wins the game!"
  else
    "Computer wins the game. Better luck next time!"
  end
end

get '/' do
  if session[:player_score].nil? && session[:computer_score].nil?
    starting_scores
  end
  game_winner

  erb :index, locals: { message: flash[:message], player_choice: session[:player_choice],
    player_score: session[:player_score], computer_score: session[:computer_score] }
end

post '/' do
  session[:player_choice] = params["player_choice"]
  session[:computer_pick] = computer_pick
  score
  starting_scores
  redirect '/'
end

post '/game_over' do
  starting_scores
  redirect '/'
end
