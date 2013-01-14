require File.dirname(__FILE__) + '/../test_helper'

class SearchIssuesControllerTest < ActionController::TestCase
  fixtures :projects, :issues

  def setup
    public_project = Project.where(:is_public => true).first
    @some_subject = public_project.issues.first.subject
  end

  def test_can_search_issues
    post :index, :query => @some_subject, :format => 'json'
    assert_response :success
  end
end
