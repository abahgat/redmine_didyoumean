module RedmineDidyoumean
  module Patches
    module SearchIssuesHelperPatch
      def issues_didyoumean_event_type
        if Setting.plugin_redmine_didyoumean['start_search_when'] == "1"
          "keyup"
        else
          "change"
        end
      end
    end
  end
end
