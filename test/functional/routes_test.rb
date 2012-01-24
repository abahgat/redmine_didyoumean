# Tests in this file ensure that:
#
# * Routes from the plugins can be routed

require File.dirname(__FILE__) + '/../test_helper'

class RoutesTest < ActionController::TestCase
  tests TestRoutingController
  
	def test_similar_issues_route
	  path = '/searchissues'
    opts = {:controller => 'search_issues', :action => 'index', :format => 'json'}
    assert_routing path, opts
    assert_recognizes opts, path
  end

end