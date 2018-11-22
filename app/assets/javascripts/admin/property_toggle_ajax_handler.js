function PropertyToggleAjaxHandler(options) {
  this.actionsContainer = options.actionsContainer;
  this.publishLinkAttribute = options.publishLinkAttribute;
  this.unpublishLinkAttribute = options.unpublishLinkAttribute;
  this.csrfToken = options.csrfToken;
}

PropertyToggleAjaxHandler.prototype.publishAjaxRequest = function(event) {
  event.preventDefault();
  _this = this;
  $.ajax({
    url: $(event.target).attr('data-publish-url'),
    type: 'PUT',
    data:  JSON.stringify({ id: $(event.target).attr('data-id') }),
    contentType: 'application/json',
    dataType: 'json',
    beforeSend: function (xhr) {
      xhr.setRequestHeader('X-CSRF-Token', _this.csrfToken)
    },
    error: function(XMLHttpRequest, errorTextStatus, error) {
      console.log("Failed: " + errorTextStatus + " ;" + error);
    },
    success: function(dealJson) {
      if(dealJson.status === 'error') {
        _this.errorDiv.text(dealJson.error_message).removeClass('hidden');
        window.setTimeout(_this.hideErrorDiv.bind(_this), 3000);
      } else {
        _this.hideErrorDiv();
        $("[data-type='deal-date'][data-id='" + $(event.target).attr('data-id') + "']").html(dealJson.published_at);
        $(event.target).attr("data-type", 'unpublish-link').text('Unpublish');
      }
    }
  });
}

PropertyToggleAjaxHandler.prototype.unpublishAjaxRequest = function(event) {
  event.preventDefault();
  _this = this;
  $.ajax({
    url: $(event.target).attr('data-unpublish-url'),
    type: 'PUT',
    data:  JSON.stringify({ id: $(event.target).attr('data-id') }),
    contentType: 'application/json',
    dataType: 'json',
    beforeSend: function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', _this.csrfToken)
    },
    error: function(XMLHttpRequest, errorTextStatus, error) {
      console.log('Failed: ' + errorTextStatus + ' ;' + error);
    },
    success: function(data) {
      _this.hideErrorDiv();
      $("[data-type='deal-date'][data-id='" + $(event.target).attr('data-id') + "']").html('-');
      $(event.target).attr('data-type', 'publish-link').text('Publish');
    }
  });
}

PropertyToggleAjaxHandler.prototype.hideErrorDiv = function() {
  this.errorDiv.addClass('hidden');
}

PropertyToggleAjaxHandler.prototype.appendErrorDiv = function() {
  this.errorDiv = $('<div>').addClass('alert alert-dismissible alert-danger hidden');
  $('header').after(this.errorDiv);
}

PropertyToggleAjaxHandler.prototype.attachActionHandlers = function() {
  this.actionsContainer.on("click", this.publishLinkAttribute, this.publishAjaxRequest.bind(this));
  this.actionsContainer.on("click", this.unpublishLinkAttribute, this.unpublishAjaxRequest.bind(this));
};

PropertyToggleAjaxHandler.prototype.init = function() {
  this.attachActionHandlers();
  this.appendErrorDiv();
};

$(document).ready(function() {
  var options = {
    "actionsContainer" : $("[data-type='actions-container']"),
    "publishLinkAttribute" : "[data-type='publish-link']",
    "unpublishLinkAttribute" : "[data-type='unpublish-link']",
    "csrfToken" : $('meta[name="csrf-token"]').attr('content')
  },

    propertyToggleAjaxHandler = new PropertyToggleAjaxHandler(options);
  propertyToggleAjaxHandler.init();
});
