function observeIssueSubjectField() {

  $('issue_subject').observe('change', function(event){
    console.log(Event.element(event).value);
  });

  drawSimilarIssuesBlock();

}

function drawSimilarIssuesBlock() {
  
  $('issue_subject').up().insert({after: $('similar_issues')});

}

function populateSimilarIssuesBlock(items) {
  
  $('issue_list').descendants().remove();

  for (var i = items.length - 1; i >= 0; i--) {
    var item_html = // display items[i]
    $('issue_list').insert({top: item_html});
  };

  if (! $('similar_issues').visible()) {
    $('similar_issues').show();
  }

}

function emptySimilarIssuesBlock() {
  
  $('issue_list').descendants().remove();

  if ($('similar_issues').visible()) {
    $('similar_issues').hide();
  }

}