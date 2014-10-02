function observeIssueSubjectField(project_id, issue_id, event_type) {
  
  if (window.jQuery) {
    $(document).ready(moveSimilarIssuesRoot)
  } else {
    document.observe("dom:loaded", moveSimilarIssuesRoot)
  }

  var handleUpdate = function(event) {
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
          updateSimilarIssuesBlock(data);
        }});
    } else {
      new Ajax.Request(url, {
        parameters: parameters,
        onSuccess: function(transport) {
          updateSimilarIssuesBlock(transport.responseJSON);
        },
        evalJSON: true
      });
    }
  }
  
  function throttle(f, delay) {
    var timer = null;
    return function() {
      var context = this, args = arguments;
      clearTimeout(timer);
      timer = window.setTimeout(function() {
          f.apply(context, args);
      },
      delay || 500);
    };
  }
  
  if (window.jQuery) {
    if (event_type === 'keyup') {
      getElem('issue_subject').attr('autocomplete', 'off');
      getElem('issue_subject').bind(event_type, throttle(handleUpdate));
    } else {
      getElem('issue_subject').bind(event_type, handleUpdate);
    }
  } else {
    if (event_type === 'keyup') {
      getElem('issue_subject').writeAttribute('autocomplete', 'off');
      getElem('issue_subject').observe(event_type, throttle(handleUpdate));
    } else {
      getElem('issue_subject').observe(event_type, handleUpdate);
    }
  }
}

function updateSimilarIssuesBlock(data) {
  var items = data.issues;
  if(items.length == 0) {
    getElem('similar_issues').hide();
  } else {
    var items_html = '';
    for (var i = 0; i < items.length; i++) {
      items_html += displayItem(items[i]);
    }

    if (data.total > data.issues.length) {
      var more = data.total - data.issues.length;
      var more_text = '<li>' + more + ' ' + dym.label_more + '</li>'
      items_html += more_text
    }

    setHtml(getElem('similar_issues_list'), items_html);
    setHtml(getElem('issues_count'), data.total);
    getElem('similar_issues').show();
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

function moveSimilarIssuesRoot() {
  var block_to_move = getElem('similar_issues_root');
  if (window.jQuery) {
    getElem('issue_subject').parent().after(block_to_move);
  } else {
    getElem('issue_subject').up().insert({after: block_to_move});
  }
}

function sanitize(value) {
  var html_safe = value.replace(/[<]+/g, '&lt;')
                       .replace(/[>]+/g, '&gt;')
                       .replace(/["]+/g, '&quot;')
                       .replace(/[']+/g, '&#039;');
  return html_safe;
}

function getElem(element_id) {
  var the_id = element_id;
  if (window.jQuery) {
    the_id = '#' + the_id;
  }
  return $(the_id);
}

function setHtml(elem, value) {
  if (elem.text) {
    elem.html(value);
  } else {
    elem.innerHTML = value;
  }
}
