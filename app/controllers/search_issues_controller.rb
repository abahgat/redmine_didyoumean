class SearchIssuesController < ApplicationController
  unloadable

  def index
  
    @query = params[:query] || ""   
    @query.strip!

    logger.info "Got request for [#{@query}]"
    logger.debug "Did you mean settings: #{Setting.plugin_redmine_didyoumean.to_json}"

    all_words = true # if true, returns records that contain all the words specified in the input query

    # extract tokens from the query
    # eg. hello "bye bye" => ["hello", "bye bye"]
    @tokens = @query.scan(%r{((\s|^)"[\s\w]+"(\s|$)|\S+)}).collect {|m| m.first.gsub(%r{(^\s*"\s*|\s*"\s*$)}, '')}
    # tokens must be at least 2 characters long
    @tokens = @tokens.uniq.select {|w| w.length > 1 }

    if !@tokens.empty?
      # no more than 5 tokens to search for
      # this is probably too strict, in this use case
      @tokens.slice! 5..-1 if @tokens.size > 5

      if all_words
        separator = ' AND '
      else
        separator = ' OR '
      end

      @tokens.map! {|cur| '%' + cur +'%'}

      conditions = (['lower(subject) like lower(?)'] * @tokens.length).join(separator)
      variables = @tokens

      # pick the current project
      project = Project.find(params[:project_id]) unless params[:project_id].blank?
      
      case Setting.plugin_redmine_didyoumean['project_filter']
      when '2'
        project_tree = Project.all
      when '1'
        # search subprojects too
        project_tree = project ? (project.self_and_descendants.active) : nil
      when '0'
        project_tree = [project]
      else
        logger.warn "Unrecognized option for project filter: [#{Setting.plugin_redmine_didyoumean['project_filter']}], skipping"
      end

      if project_tree
        # check permissions
        scope = project_tree.select {|p| User.current.allowed_to?(:view_issues, p)}
        logger.info "Set project filter to #{scope}"
        conditions += " AND project_id in (?)"
        variables << scope
      end
      
      if Setting.plugin_redmine_didyoumean['show_only_open'] == "1"
        valid_statuses = IssueStatus.all(:conditions => ["is_closed <> ?", true])
        logger.info "Valid status ids are #{valid_statuses}"
        conditions += " AND status_id in (?)"
        variables << valid_statuses
      end

      limit = Setting.plugin_redmine_didyoumean['limit']
      limit = 5 if limit.nil? or limit.empty?
      @issues = Issue.find(:all, :conditions => [conditions, *variables], :limit => limit)
      @count = Issue.count(:all, :conditions => [conditions, *variables])

      logger.info "#{@count} results found, returning the first #{@issues.length}"

      # order by decreasing creation time. Some relevance sort would be a lot more appropriate here
      @issues = @issues.sort {|a,b| b.id <=> a.id}
      

    else
      @query = ""
      @count = 0
      @issues = []
    end

    render :json => { :total => @count, :issues => @issues.map!{|i| i.as_json(:include => [:status, :tracker, :project])}}
  end
end
