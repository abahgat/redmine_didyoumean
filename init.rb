require 'redmine'

Redmine::Plugin.register :redmine_didyoumean do
  name 'Did You Mean plugin'
  author 'Alessandro Bahgat'
  description 'A plugin to search for duplicate issues before opening them.'
  version '0.0.1'
  url 'http://www.github.com/abahgat/redmine_didyoumean'
  author_url 'http://abahgat.com/'
  settings(:default => {'show_only_open' => '1'}, :partial => 'settings/settings')
end

require 'redmine_didyoumean/hooks/didyoumean_hooks'
