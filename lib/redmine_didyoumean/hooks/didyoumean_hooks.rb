module DidYouMean
  class DidYouMeanHooks < Redmine::Hook::ViewListener
    render_on(:view_issues_form_details_bottom,
              :partial => 'issues/didyoumean_injected.html.erb')
  end
end
