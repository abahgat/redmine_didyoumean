require 'redmine'
require 'redmine_did_you_mean'

require_relative './app/indices/issue_index'

Redmine::Plugin.register :redmine_didyoumean do
  name 'Did You Mean?'
  author 'Alessandro Bahgat and Mattia Tommasone'
  description 'A plugin to search for duplicate issues before opening them.'
  version '1.2.0'
  url 'http://www.github.com/abahgat/redmine_didyoumean'
  author_url 'http://abahgat.com/'

  default_settings = {
    'show_only_open' => '1',
    'project_filter' => '1',
    'min_word_length' => '2',
    'limit' => '5',
    'start_search_when' => '0',
    'search_method' => '0'
  }

  settings(:default => default_settings, :partial => 'settings/didyoumean_settings')
end

require 'redmine_didyoumean/hooks/didyoumean_hooks'

ActiveSupport.on_load :after_initialize, yield: true do
  require 'redmine_didyoumean/patches/alias_ts_search_patch'
  require 'redmine_didyoumean/patches/monkey_after_destroy_patch'
end
