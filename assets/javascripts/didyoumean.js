function observeIssueSubjectField() {
  $('issue_subject').observe('change', function(event){
    console.log(Event.element(event).value);
  });
  drawSimilarIssuesBlock();
}

function drawSimilarIssuesBlock() {
	var similar_issues_tpl = 
		'<div class="similar_issues">\
			<b>Issues with similar titles</b>\
			<ul class="issue_list">\
				<li><a>#1: subject of issue 1</a> (status)</li><li><a>#2: subject of issue 2</a> (status)</li>\
			</ul>\
		</div>';
	$('issue_subject').up().insert({after: similar_issues_tpl});
}