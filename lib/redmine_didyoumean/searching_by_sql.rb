module RedmineDidYouMean
  class SqlSearch

    def search project_tree, issue_id, query, limit
      set_variables query
      get_conditions project_tree, issue_id
      set_results limit
    end

    private

    def initialize
      @query = Issue.visible.order("issues.id DESC")

      all_words = true
      @min_length = Setting.plugin_redmine_didyoumean['min_word_length'].to_i
      @separator = all_words ? ' AND ' : ' OR '
    end

    def set_variables query
      @variables = query.scan(%r{((\s|^)"[\s\w]+"(\s|$)|\S+)}).collect {|m| m.first.gsub(%r{(^\s*"\s*|\s*"\s*$)}, '')}
      @variables = @variables.uniq.select {|w| w.length >= @min_length }
      @variables.slice! 5..-1 if @variables.size > 5
      @variables.map! {|cur| '%' + cur +'%'}
    end

    def project_condition project_tree
      scope = project_tree.select {|p| User.current.allowed_to?(:view_issues, p)}.collect(&:id)
      @query = @query.where(project_id: scope)
    end

    def only_open_condition
      valid_statuses = IssueStatus.where("is_closed <> ?", true).collect(&:id)
      @query = @query.where(status_id: valid_statuses)
    end

    def edited_condition issue_id
      @query = @query.where('issues.id != ?', issue_id)
    end

    def get_conditions project_tree, issue_id
      variables_condtions
      project_condition(project_tree) if project_tree
      only_open_condition if Setting.plugin_redmine_didyoumean['show_only_open'] == "1"
      edited_condition(issue_id) unless issue_id.nil? || issue_id.blank?
    end

    def variables_condtions
      @variables.each do |v|
        @query = @query.where('lower(subject) like lower(?)', v)
      end
    end

    def set_results limit
      issues = @query.limit(limit)
      count = @query.count
      return issues, count
    end
  end
end
