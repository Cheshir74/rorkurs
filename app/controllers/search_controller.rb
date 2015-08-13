class SearchController < ApplicationController
  skip_authorization_check

  def index
    search = params[:query]
    type_search = params[:type]

    if type_search == 'All'
      @results = ThinkingSphinx.search(search)
    else
      @results = type_search.constantize.search(search)
    end
  end
end