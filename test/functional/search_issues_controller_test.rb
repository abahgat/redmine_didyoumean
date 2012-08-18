require File.dirname(__FILE__) + '/../test_helper'

class SearchIssuesControllerTest < ActionController::TestCase
  fixtures :projects

  def setup
    public_project = Project.first(["is_public=?", true])
    @some_subject = public_project.issues.first.subject
  end

  def test_can_search_issues
    post :index, :query => @some_subject, :format => 'json'
    assert_response :success
  end
end
