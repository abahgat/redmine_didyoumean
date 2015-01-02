require File.expand_path('../../test_helper', __FILE__)

include RedmineDidyoumean

class SearchIssuesControllerSqlTest < ActionController::TestCase

  tests SearchIssuesController

  def setup_sql
    settings_sql
    project = Project.first
    @some_subject = project.issues.first.subject
  end

  def settings_sql
    Setting.destroy_all
    Setting.clear_cache
    Setting['plugin_redmine_didyoumean'] = {
      'show_only_open' => '0',
      'project_filter' => '2',
      'min_world_length' => '2',
      'limit' => '5',
      'start_search_when' => '0',
      'search_method' => '0'
    }
  end

  test 'can_search_issues_by_sql' do
    setup_sql
    post :index, query: @some_subject, format: 'json'
    assert_response :success
  end

  test 'get results sql' do
    setup_sql
    get :index, project_id: 1, issue_id: '', query: 'GUI', format: 'json'
    body = JSON.parse(response.body)
    assert_equal 2, body['total'], 'Wrong number of issues'
    assert_equal 'Graphic design GUI', body['issues'].first['subject'], 'Subject is different!'
    assert_equal 'New', body['issues'].first['status_name'], 'Wrong status name!'
    assert_equal 'GUI issues list', body['issues'].last['subject'], 'Wrong second issue subject!'
  end

  test 'edit exisitng issue with sql' do
    setup_sql
    get :index, project_id: 1, issue_id: 1,  query: 'GUI', format: 'json'
    body = JSON.parse(response.body)
    assert_equal 1, body['total'], 'Wrong total issues!'
  end

  test 'destroy issue without errors with sql' do
    setup_sql
    assert_difference 'Issue.count', -1 do
      Issue.first.destroy
    end
  end
end
