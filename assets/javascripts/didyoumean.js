function observeIssueSubjectField() {
  $('issue_subject').observe('keypress', function(event){
    console.log(Event.element(event).value);
  });
}