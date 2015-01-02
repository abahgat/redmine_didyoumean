# nasty workaround
# problem: ThinkingSphinx add after_destroy hook to clean up indices,
#   even if you set up SQL Search Engine hook exists
#   and provides to error ThinkingSphinx::SphinxError Lost connection to MySQL server
# solution: if TS is disabled do not try clean up idices
module TSMonkeyPatch
  def patch_after_destroy
    class_eval do
      def perform_with_dym
        return name == 'issue_core' && Setting.plugin_redmine_didyoumean['search_method'] != '1'
        perform_without_dym
      end
      alias_method_chain :perform, :dym
    end
  end
end


[ThinkingSphinx::Deletion::RealtimeDeletion, ThinkingSphinx::Deletion::PlainDeletion].each do |klazz|
  klazz.extend(TSMonkeyPatch)
  klazz.patch_after_destroy
end
