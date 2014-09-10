# protect redmine search method
module ThinkingSphinx::ActiveRecord::Base::ClassMethods
  if defined? :search
    alias_method :sphinx_search, :search
    remove_method :search
  end
end
