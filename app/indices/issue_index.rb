if %w(mysql2 mysql postgresql).include?(ActiveRecord::Base.connection.instance_values["config"][:adapter] )
  ThinkingSphinx::Index.define :issue, :with => :active_record do
    # fields
    indexes subject, :sortable => true

    # properties
    set_property :enable_star => 1
    set_property :min_infix_len => Setting.plugin_redmine_didyoumean['min_word_length']

    # attributes
    has :id, :status_id, :project_id
  end
end
