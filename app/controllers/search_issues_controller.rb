class SearchIssuesController < ApplicationController
  unloadable


  def index
    @query = params[:query] || ""
    @query.strip!

    logger.info "Got request for #{@query}"

    @all_words = true # is it necessary?
    @titles_only = true

    # TODO handle subprojects, or parent & siblings, look in search_controller.rb in Redmine
    # pick the current project
    projects_to_search = nil

    # TODO do we need to call this User.current.allowed_to?("view_issues", projects_to_search)
    # is it possible to add issues without being able to view them?
    
    # extract tokens from the query
    # eg. hello "bye bye" => ["hello", "bye bye"]
    @tokens = @query.scan(%r{((\s|^)"[\s\w]+"(\s|$)|\S+)}).collect {|m| m.first.gsub(%r{(^\s*"\s*|\s*"\s*$)}, '')}
    # tokens must be at least 2 characters long
    @tokens = @tokens.uniq.select {|w| w.length > 1 }

    if !@tokens.empty?
      # no more than 5 tokens to search for
      @tokens.slice! 5..-1 if @tokens.size > 5

      @results = []

      limit = 10
      r, c = Issue.search(@tokens, projects_to_search,
        :all_words => @all_words,
        :titles_only => @titles_only,
        :limit => (limit+1))
      @results += r

      @count = c

      logger.info "Got #{c} results"

      # what a lame ordering
      @results = @results.sort {|a,b| b.event_datetime <=> a.event_datetime}
    else
      @query = ""
    end
  end
end
