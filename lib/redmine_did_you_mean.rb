require 'redmine_didyoumean/searching_by_sql'
require 'redmine_didyoumean/searching_by_thinking_sphinx'

module RedmineDidYouMean

  def get_search_method
    @results = search_class.new.search @project_tree, params[:issue_id], @query, @limit
  end

  private

  def search_class
    case Setting.plugin_redmine_didyoumean['search_method']
    when "0"
      SqlSearch
    when "1"
      ThinkingSphinxSearch
    else
      raise 'There is no search method selected!'
    end
  end

  def get_project_filter
    case Setting.plugin_redmine_didyoumean['project_filter']
    when '3'
      @project_tree = @project ? @project.root.self_and_descendants.active : nil
    when '2'
      @project_tree = Project.all
    when '1'
      @project_tree = @project ? @project.self_and_descendants.active : nil
    when '0'
      @project_tree = [@project]
    else
      logger.warn "Unrecognized option for project filter: [#{Setting.plugin_redmine_didyoumean['project_filter']}], skipping"
    end
  end

  def results_to_json
    {
      :total => @count,
      :issues => @issues.map do |i|
        {
          :id => i.id,
          :tracker_name => i.tracker.name,
          :subject => i.subject,
          :status_name => i.status.name,
          :project_name => i.project.name
        }
      end
    }
  end

  def find_project
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
  end

  def get_query
    @query = params[:query] || ""
    @query.strip!
  end

  def get_limit
    @limit = Setting.plugin_redmine_didyoumean['limit'] || 5 if @limit.nil? or @limit.empty?
  end

  def get_results
    if !@query.blank?
      get_search_method
      @issues = @results.first
      @count = @results.last
    else
      @query = ""
      @count = 0
      @issues = []
    end
  end
end
