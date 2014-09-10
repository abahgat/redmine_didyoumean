# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class ActionController::TestCase


  # XXX: redmine master branch is not compatible with other branches
  fx = [:projects, :issues, :users, :settings, :members, :roles, :enabled_modules]
  fx2 = [:issue_statuses, :trackers]

  fixtures *fx
  fixtures *fx2

  if Gem::Version.new(Rails.version) >= Gem::Version.new('4.0')
    ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/master/', fx2)
  else
    ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/default/', fx2)
  end

  ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/', fx)
end
