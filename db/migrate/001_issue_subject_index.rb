class IssueSubjectIndex < ActiveRecord::Migration
  def self.up
    add_index :issues, :subject
  end

  def self.down
    remove_index :issues, :subject
  end
end