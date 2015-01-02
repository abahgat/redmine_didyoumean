require File.expand_path('../../test_helper', __FILE__)
require 'thinking_sphinx/test'

include RedmineDidyoumean

class SearchIssuesControllerTest < ActionController::TestCase

  def setup_main
    Setting.destroy_all
    Setting.clear_cache
    Setting['plugin_redmine_didyoumean'] = {
      'show_only_open' => '0',
      'project_filter' => '1',
      'min_world_length' => '2',
      'limit' => '5',
      'start_search_when' => '0',
      'search_method' => '0'
    }
    project = Project.first
    @some_subject = project.issues.first.subject
  end

  test 'fixtures_works? main' do
    setup_main
    assert_equal 1, User.count, 'Wrong users count'
  end

  test 'can_search_issues main' do
    setup_main
    post :index, :query => @some_subject, :format => 'json'
    assert_response :success
  end

  test 'query main' do
    setup_main
    get :index, :project_id => 1, :query => "GUI", :format => 'json'
    body = JSON.parse(response.body)
    assert_equal 2, body["total"], 'Not allowed to see issues'
  end
end
