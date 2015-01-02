if Rails::VERSION::MAJOR < 3
  ActionController::Routing::Routes.draw do |map|
    map.plugin_route 'searchissues', :controller => "search_issues", :action => 'index'
  end
else
  get 'searchissues', :controller => "search_issues", :action => 'index'
end
