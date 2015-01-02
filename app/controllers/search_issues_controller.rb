class SearchIssuesController < ApplicationController
  unloadable

  include RedmineDidYouMean

  before_filter :find_project, :get_query, :get_project_filter, :get_limit


  def index
    get_results
    render :json => results_to_json
  end

end
