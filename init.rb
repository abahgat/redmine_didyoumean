require 'redmine'

Redmine::Plugin.register :redmine_didyoumean do
  name 'Did You Mean plugin'
  author 'Alessandro Bahgat'
  description 'A plugin to search for duplicate issues before insertion'
  version '0.0.1'
  url 'http://www.github.com/abahgat/didyoumean'
  author_url 'http://abahgat.com/'
end

require 'redmine_didyoumean/hooks/didyoumean_hooks'
