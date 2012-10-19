module IssuesHelper
  def issues_didyoumean_event_type
    if Setting.plugin_redmine_didyoumean['use_incremental_search'] == "1"
      "keyup"
    else
      "change"
    end
  end
end
