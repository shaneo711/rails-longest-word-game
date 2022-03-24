require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      letter = ('A'..'Z').to_a.sample
      @letters << letter
    end
  end

  def score
    @attempt = params[:attempt]
    @grid = params[:grid].split

    # Check for letters not in the grid.
    @attempt.upcase.chars.each do |letter|
      if @grid.include?(letter)
        @grid.delete_at(@grid.index(letter))
        # Check if word is english word.
        word_info = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}").read)
        @valid = word_info['found']
        if @valid == false
          @message = "Sorry but #{@attempt.upcase} does not seem to be a valid English word..."
        else
          @message = "Congratulations! #{@attempt.upcase} is a valid English word!"
        end
      else
        @message = 'Your word includes letters not in the grid. FAIL!'
      end
    end
  end
end
