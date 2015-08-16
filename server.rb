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
  choices = ["Rock", "Paper", "Scissors"]
  choices.sample
end

def score
  until session[:player_score] == 2 || session[:computer_score] == 2
    if (session[:player_choice] == "Rock" && session[:computer_pick] == "Scissors") || (session[:player_choice] == "Paper" && session[:computer_pick] == "Rock") || (session[:player_choice] == "Scissors" && session[:computer_pick] == "Paper")
      session[:player_score] += 1
      session[:round_message] = "Player won."
    elsif (session[:computer_pick] == "Rock" && session[:player_choice] == "Scissors") || (session[:computer_pick] == "Paper" && session[:player_choice] == "Rock") || (session[:computer_pick] == "Scissors" && session[:player_choice] == "Paper")
      session[:computer_score] += 1
      session[:round_message] = "Computer won."
    elsif (session[:computer_pick] == session[:player_choice])
      session[:round_message] = "Tie, choose again."
    end
  redirect "/"
 end
end

def game_winner
  if session[:player_score] >= 2
    params[:winner_message] = "Player wins the game!"
  else
    params[:winner_message] = "Computer wins the game. Better luck next time!"
  end
end

get '/' do
  if session[:player_score].nil? && session[:computer_score].nil?
    starting_scores
  end
  game_winner

  erb :index, locals: { winner_message: session[:winner_message],
    round_message: session[:round_message], player_choice: session[:player_choice],
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
