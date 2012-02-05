class SearchIssuesController < ApplicationController
  unloadable

  def index
  
  	@query = params[:query] || ""  	
    @query.strip!

    logger.info "Got request for [#{@query}]"

    @all_words = true # if true, returns records that contain all the words specified in the input query

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
      # this is probably too strict, in this use case
      @tokens.slice! 5..-1 if @tokens.size > 5

      if @all_words:
        separator = ' AND '
      else
        separator = ' OR '
      end

      tokens = []
	    @tokens.each do |cur|
	  	  tokens << '%' + cur +'%'
      end

      conditions = (['subject like ?'] * tokens.length).join(separator)

      limit = 10
      @issues = Issue.find(:all, :conditions => [conditions, *tokens], :include => [:assigned_to, :status, :tracker], :joins => [:status, :tracker], :limit => limit)

      logger.info "Got #{@issues.length} results"

      # what a lame ordering
      #@results = @results.sort {|a,b| b.event_datetime <=> a.event_datetime}
      

    else
      @query = ""
    end

    logger.info @issues.to_json
    render :json => @issues.to_json(:include => [:status, :tracker])

  end
end
