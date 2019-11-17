require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    arr1 = [*('A'..'Z')].sample(10)
    arr2 = [*('A'..'Z')].sample(10)
    @word = (arr1 + arr2).sample(10)
    @start_time = Time.now
  end

  def score
    check
  end

  private

  def check
    @attempt = params[:word]
    grid = params[:grid]
    end_time = Time.now
    start_time = Time.parse(params[:start_time])
    @time = end_time - start_time
    @score = 0
    @message = 'This word is not in the grid'
    attempt_array = @attempt.upcase.split('')
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    open_web = open(url).read
    dictionary = JSON.parse(open_web)
    if dictionary['found'] && check_word(attempt_array, grid)
      @score = @attempt.length * 2 - @time * 0.5
      @message = 'Well done!'
    elsif !dictionary['found']
      @message = 'This is not an english word'
    end
    { score: @score, time: @time, message: @message }
  end

  def check_word(letters, grid)
    grid_array = grid.split
    letters.all? do |char|
      grid_array.delete_at(grid_array.index(char)) if grid_array.include?(char)
    end
  end
end
