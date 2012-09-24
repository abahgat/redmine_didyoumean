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

  var issue_url = sanitize(dym.issue_url + '/' + item.id);
  var tracker_name = sanitize(item.tracker_name);
  var item_id = sanitize('#' + item.id);
  var item_subject = sanitize(item.subject);
  var item_status = sanitize(item.status_name);
  var project_name = sanitize(item.project_name);

  var item_html = '<li><a href="' + issue_url + '">' 
    + tracker_name 
    + ' ' + item_id
    + ' &ndash; ' 
    + item_subject
    + '</a> ('
    + item_status
    + ' ' 
    + dym.label_in
    + ' ' + project_name
    + ')</li>';

  return item_html;
}

function sanitize(value) {
  
  var html_safe = value.replace(/[<]+/g, '&lt;')
                      .replace(/[>]+/g, '&gt;')
                      .replace(/["]+/g, '&quot;')
                      .replace(/[']+/g, '&#039;');
  return html_safe;
}

function emptySimilarIssuesBlock() {
  
  $('similar_issues_list').innerHTML = '';

  if ($('similar_issues').visible()) {
    $('similar_issues').hide();
  }

}
