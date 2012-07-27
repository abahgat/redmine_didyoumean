if Rails::VERSION::MAJOR < 3
  ActionController::Routing::Routes.draw do |map|
    map.plugin_route 'searchissues', :controller => "search_issues", :action => 'index', :format => 'json'
  end
else
  match 'searchissues', :controller => "search_issues", :action => 'index', :format => 'json'
end
