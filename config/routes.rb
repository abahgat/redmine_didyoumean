ActionController::Routing::Routes.draw do |map|
  map.plugin_route 'searchissues', :controller => "search_issues", :action => 'index', :format => 'json'
end