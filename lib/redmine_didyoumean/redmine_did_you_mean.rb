module RedmineDidYouMean

  def check_for_conditions_and_settings

    @conditions = {}
    @edited_issue = {}

    if !params[:issue_id].blank?
      @edited_issue[:id] = params[:issue_id]
    end

    if @project_tree
      permited_to = @project_tree.select{|p| User.current.allowed_to?(:view_issues, p)}
      @conditions[:project_id] = permited_to.collect(&:id)
    end

    if Setting.plugin_redmine_didyoumean['show_only_open'] == "1"
      @conditions[:status_id] = IssueStatus.where(is_closed: false).collect(&:id)
    end
    @limit = Setting.plugin_redmine_didyoumean['limit'] || 5 if @limit.nil? or @limit.empty?
  end

  private

  def get_project_filter
    case Setting.plugin_redmine_didyoumean['project_filter']
    when '2'
      @project_tree = Project.all
    when '1'
      @project_tree = @project ? (@project.self_and_descendants.active) : nil
    when '0'
      @project_tree = [@project]
    else
      logger.warn "Unrecognized option for project filter: [#{Setting.plugin_redmine_didyoumean['project_filter']}], skipping"
    end
  end

end
