class SearchIssuesController < ApplicationController
  unloadable

  def index
  
  	@query = params[:query] || ""  	
    @query.strip!

    logger.info "Got request for [#{@query}]"

    @all_words = true # if true, returns records that contain all the words specified in the input query

    # pick the current project
    project = Project.find(params[:project_id]) unless params[:project_id].blank?
    # search subprojects too
    project_tree = project ? (project.self_and_descendants.active) : nil

    # check permissions
    scope = project_tree.select {|p| User.current.allowed_to?(:view_issues, p)}

    logger.info "The current project scope is #{scope}"

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

      conditions = (['subject like ?'] * tokens.length).join(separator) + " AND project_id in (?)"

      limit = 10
      @issues = Issue.find(:all, :conditions => [conditions, *tokens << scope], :include => [:status, :tracker, :project], :joins => [:status, :tracker], :limit => limit)

      logger.info "Got #{@issues.length} results"

      # what a lame ordering
      #@results = @results.sort {|a,b| b.event_datetime <=> a.event_datetime}
      

    else
      @query = ""
    end

    logger.info @issues.to_json
    render :json => @issues.to_json(:include => [:status, :tracker, :project])
  end
end
