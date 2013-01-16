require 'redmine'

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
    'start_search_when' => '0'
  }

  settings(:default => default_settings, :partial => 'settings/didyoumean_settings')
end

ActionDispatch::Callbacks.to_prepare do
  require 'redmine_didyoumean/hooks/didyoumean_hooks'
  IssuesHelper.send :include, RedmineDidyoumean::Patches::SearchIssuesHelperPatch
end
