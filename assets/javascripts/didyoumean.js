function observeIssueSubjectField(project_id, issue_id) {

  var drawCallback = function(data) {
    if (data.total) {
      drawSimilarIssuesBlock();
      populateSimilarIssuesBlock(data);
    }
  };

  var handleChange = function(event) {

    emptySimilarIssuesBlock();
    var url = dym.search_url;
    var parameters = {
      project_id: project_id,
      issue_id: issue_id,
      query: (window.jQuery ? $(this).val() : Event.element(event).value)
    };

    if (window.jQuery) {
      new $.ajax(url, {
        data: parameters,
        success: function(data, textStatus, jqXHR) {
          drawCallback(data);
        }});
    } else {
      new Ajax.Request(url, {
        parameters: parameters,
        onSuccess: function(transport) {
          drawCallback(transport.responseJSON);
        },
        evalJSON: true
      });
    }
  }
  
  if (window.jQuery) {
    getElem('issue_subject').change(handleChange);
  } else {
    getElem('issue_subject').observe('change', handleChange);
  }
}

function drawSimilarIssuesBlock() {

  if (window.jQuery) {
    getElem('issue_subject').parent().after(getElem('similar_issues'));
  } else {
    getElem('issue_subject').up().insert({after: getElem('similar_issues')});
  }

}

function populateSimilarIssuesBlock(data) {

  setText(getElem('similar_issues_list'), '');
  
  var items = data.issues;
  for (var i = items.length - 1; i >= 0; i--) {
    var item_html = displayItem(items[i]);
    if (window.jQuery) {
      getElem('similar_issues_list').prepend(item_html);
    } else {
      getElem('similar_issues_list').insert({top: item_html});
    }
  };

  setText(getElem('issues_count'), data.total);
  getElem('similar_issues').show();

  if (data.total > data.issues.length) {
    var more = data.total - data.issues.length;
    if (window.jQuery) {
      getElem('similar_issues_list').append('<li>+' + more + ' ' + dym.label_more + '</li>');
    } else {
      getElem('similar_issues_list').insert({bottom: '<li>+' + more + ' ' + dym.label_more + '</li>'});
    }
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

  setText(getElem('similar_issues_list'), '');
  getElem('similar_issues').hide();

}

function getElem(element_id) {
  var the_id = element_id;
  if (window.jQuery) {
    the_id = '#' + the_id;
  }
  return $(the_id);
}

function setText(elem, value) {
  if (elem.text) {
    elem.text(value);
  } else {
    elem.innerHTML = value;
  }
}
