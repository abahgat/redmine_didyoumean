function observeIssueSubjectField() {

  $('issue_subject').observe('change', function(event){
  	emptySimilarIssuesBlock();
    var url = '/searchissues?query=' + Event.element(event).value;
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
  
  $('issue_list').innerHTML = '';
  
  for (var i = items.length - 1; i >= 0; i--) {
    var item_html = displayItem(items[i]);
    $('issue_list').insert({top: item_html});
  };

 $('issues_count_value').innerHTML = items.length;
  if (! $('similar_issues').visible()) {
    $('similar_issues').show();
  }

}

function displayItem(item) {
	return '<li> <a href="/issues/' + item.id + '">' + item.subject + '</a></li>';
}

function emptySimilarIssuesBlock() {
  
  $('issue_list').innerHTML = '';

  if ($('similar_issues').visible()) {
    $('similar_issues').hide();
  }

}