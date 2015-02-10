require_relative "./base_search"

module RedmineDidYouMean
  class ElasticSearch < BaseSearch

    private

    def set_results query, limit
      issues = Issue.elastic_search(query, operator: "or", fields: [:subject], where: @conditions, limit: limit.to_i)
      count = issues.total_entries
      return issues, count
    rescue StandardError => ex
      Rails.logger.warn "#{ex.message}. An error occurred while searching for potential duplicate issues"
      return [], 0
    end
  end
end
