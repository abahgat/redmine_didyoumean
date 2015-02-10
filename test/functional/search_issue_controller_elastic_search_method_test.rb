require File.expand_path('../../test_helper', __FILE__)

include RedmineDidyoumean

class SearchIssuesControllerElasticSearchTest < ActionController::TestCase

  tests SearchIssuesController

  def setup
    setup_client
    setup_index
    Setting.destroy_all
    Setting.clear_cache
    Setting['plugin_redmine_didyoumean'] = {
      'show_only_open' => '0',
      'project_filter' => '2',
      'min_world_length' => '2',
      'limit' => '5',
      'start_search_when' => '0',
      'search_method' => '2'
    }
  end

  def setup_client
    config = {:hosts=>["http://127.0.0.1:9200"], :transport_options=>{:proxy=>{:uri=>""}, :headers=>{:user_agent=>"front"}, :request=>{:timeout=>60}}}
    Searchkick.client = Elasticsearch::Client.new(config)
  end

  def setup_index
    Issue.searchkick_index.delete if Issue.searchkick_index.exists?
    Issue.enable_search_callbacks
    Issue.reindex
  end

  test 'test elastic search query' do
    get :index, project_id: 1, query: 'test', format: 'json'
    body = JSON.parse(response.body)
    assert_equal 4, body["total"], 'Wrong total results!'
  end

  test 'reindex after edit' do
    issue = Issue.find(6)
    issue.subject = 'New Issue'
    issue.author = User.last
    issue.save!
    Issue.reindex #because doesn't load callbacks
    get :index, project_id: 1, query: 'test', format: 'json'
    body = JSON.parse(response.body)
    assert_equal 3, body["total"], 'Wrong total results!'
  end

  test 'reindex after destroy_all' do
    issue = Issue.destroy_all
    Issue.reindex #because doesn't load callbacks
    get :index, project_id: 1, query: 'test', format: 'json'
    body = JSON.parse(response.body)
    assert_equal 0, body["total"], 'Wrong total results!'
  end
end
