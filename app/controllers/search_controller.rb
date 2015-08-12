class SearchController < ApplicationController
  skip_authorization_check

  def index
    search = params[:query]
    type_search = params[:type]

    if type_search == 'All'
      @results = ThinkingSphinx.search(search)
    elsif type_search == 'Questions'
      @results = Question.search(search)
    elsif type_search == 'Answers'
      @results = Answer.search(search)
    elsif type_search == 'Comments'
      @results = Comment.search(search)
    elsif type_search == 'Users'
      @results = User.search(search)
    end
  end
end