require 'open-uri'

class GamesController < ApplicationController
  LETTERS = %w[A B C D E F G H I J L M N O P Q R S T U V X Z]

  def new
    grid_size = 9
    @letters = []
    grid_size.times do
      @letters << LETTERS.sample
    end
  end

  def score
    grid = params[:grid].upcase.chars
    grid_test = grid.dup
    answer = params[:answer].upcase.chars
    belongs_grid = answer.all? { |char| grid_test.delete_at grid_test.index(char) unless grid_test.index(char).nil? }
    english = JSON.parse(open('https://wagon-dictionary.herokuapp.com/' + answer.join).read)['found']

    if belongs_grid && english
      @result = "Congratulations! #{answer.join} is a valid English word"
    elsif belongs_grid
      @result = "Sorry but #{answer.join} does not seem to be a valid English word.."
    else
      @result = "Sorry but #{answer.join} can't be built out of #{grid.join(', ')}"
    end
  end
end
