function observeIssueSubjectField(project_id) {

  $('issue_subject').observe('change', function(event){
  	emptySimilarIssuesBlock();
    var url = '/searchissues?project_id=' + project_id + '&query=' + Event.element(event).value;
   	new Ajax.Request(url, {
   		onSuccess: function(transport) {
   			var data = JSON.parse(transport.responseText);
   			if(data.length) {
   				drawSimilarIssuesBlock();
   				populateSimilarIssuesBlock(data);
   			}
   		}
   	});  
  });
}

function drawSimilarIssuesBlock() {
  
  $('issue_subject').up().insert({after: $('similar_issues')});

}

function populateSimilarIssuesBlock(items) {
  
  $('similar_issues_list').innerHTML = '';
  
  for (var i = items.length - 1; i >= 0; i--) {
    var item_html = displayItem(items[i]);
    $('similar_issues_list').insert({top: item_html});
  };

 $('issues_count').innerHTML = items.length;
  if (! $('similar_issues').visible()) {
    $('similar_issues').show();
  }

}

function displayItem(item) {
	return '<li><a href="/issues/' + item.id + '">' + item.tracker.name + ' #' + item.id + ' &ndash; ' + item.subject + '</a> (' + item.status.name + ' on ' + item.project.name +')</li>';
}

function emptySimilarIssuesBlock() {
  
  $('similar_issues_list').innerHTML = '';

  if ($('similar_issues').visible()) {
    $('similar_issues').hide();
  }

}