function observeIssueSubjectField(project_id) {

  $('issue_subject').observe('change', function(event){
    emptySimilarIssuesBlock();
    var url = dym.search_url;
    new Ajax.Request(url, {
      parameters: {
        project_id: project_id,
        query: Event.element(event).value
      },
      onSuccess: function(transport) {
        var data = transport.responseJSON;
        if(data.total) {
          drawSimilarIssuesBlock();
          populateSimilarIssuesBlock(data);
        }
      },
      evalJSON: true
    });  
  });
}

function drawSimilarIssuesBlock() {
  
  $('issue_subject').up().insert({after: $('similar_issues')});

}

function populateSimilarIssuesBlock(data) {
  
  $('similar_issues_list').innerHTML = '';
  
  var items = data.issues;
  for (var i = items.length - 1; i >= 0; i--) {
    var item_html = displayItem(items[i]);
    $('similar_issues_list').insert({top: item_html});
  };

 $('issues_count').innerHTML = data.total;
  if (! $('similar_issues').visible()) {
    $('similar_issues').show();
  }
  if (data.total > data.issues.length) {
    var more = data.total - data.issues.length;
    $('similar_issues_list').insert({bottom: '<li>+' + more + ' ' + dym.label_more + '</li>'});
  }
}

function displayItem(item) {
  return '<li><a href="' + dym.issue_url + '/' + item.id + '">' + item.tracker.name + ' #' + item.id + ' &ndash; ' + item.subject + '</a> (' + item.status.name + ' ' + dym.label_in + ' ' + item.project.name +')</li>';
}

function emptySimilarIssuesBlock() {
  
  $('similar_issues_list').innerHTML = '';

  if ($('similar_issues').visible()) {
    $('similar_issues').hide();
  }

}