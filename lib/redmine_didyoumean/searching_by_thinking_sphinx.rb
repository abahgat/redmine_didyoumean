module RedmineDidYouMean
  class ThinkingSphinxSearch

    def search project_tree, issue_id, query, limit
      get_conditions issue_id, project_tree
      set_results query, limit
    end

    private

    def initialize
      @conditions = {}
      @edited_issue = 0
    end

    def project_condition project_tree
      permited_to = project_tree.select{|p| User.current.allowed_to?(:view_issues, p)}
      @conditions[:project_id] = permited_to.collect(&:id)
    end

    def only_open_conditon
      @conditions[:status_id] = IssueStatus.where(is_closed: false).collect(&:id)
    end

    def edited_issue_condition issue_id
      @edited_issue = issue_id.to_i
    end

    def get_conditions issue_id, project_tree
      edited_issue_condition(issue_id) unless issue_id.blank?
      project_condition(project_tree) if project_tree
      only_open_conditon if Setting.plugin_redmine_didyoumean['show_only_open'] == "1"
    end

    def set_results query, limit
      issues = Issue.sphinx_search query, :with => @conditions, :without_ids => [ @edited_issue ], :per_page => limit, :star => true
      count = issues.total_entries
      return issues, count
    rescue StandardError => ex
      Rails.logger.warn "#{ex.message}. An error occurred while searching for potential duplicate issues"
      return [], 0
    end
  end
end
