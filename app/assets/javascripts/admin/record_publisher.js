function RecordPublisher(options) {
  this.actionsContainer = options.actionsContainer;
  this.publishLinkAttribute = options.publishLinkAttribute;
  this.unpublishLinkAttribute = options.unpublishLinkAttribute;
  this.csrfToken = options.csrfToken;
}

RecordPublisher.prototype.publishAjaxRequest = function(event) {
  event.preventDefault();
  _this = this;
  $.ajax({
    url: $(event.target).attr('data-publish-url'),
    type: 'PUT',
    data: { id: $(event.target).attr('data-id'), authenticity_token: _this.csrfToken },
    dataType: 'json',
    error: function(XMLHttpRequest) {
      _this.appendErrorsToView($.parseJSON(XMLHttpRequest.responseText).errors);
    },
    success: function(dealJson) {
      _this.updatePropertyValue(dealJson.published_at, event, 'unpublish');
    }
  });
}

RecordPublisher.prototype.unpublishAjaxRequest = function(event) {
  event.preventDefault();
  _this = this;
  $.ajax({
    url: $(event.target).attr('data-unpublish-url'),
    type: 'PUT',
    data: { id: $(event.target).attr('data-id'), authenticity_token: _this.csrfToken },
    dataType: 'json',
    error: function(XMLHttpRequest) {
      _this.appendErrorsToView($.parseJSON(XMLHttpRequest.responseText).errors);
    },
    success: function(dealJson) {
      _this.updatePropertyValue('-', event, 'publish');
    }
  });
}

RecordPublisher.prototype.appendErrorsToView = function(errors) {
  this.errorDiv.text(errors).removeClass('hidden');
  setTimeout(this.hideErrorDiv.bind(_this), 3000);
}

RecordPublisher.prototype.updatePropertyValue = function(value, event, toggle_to) {
  this.hideErrorDiv();
  $("[data-type='publish-date'][data-id='" + $(event.target).attr('data-id') + "']").html(value);
  $(event.target).attr('data-type', toggle_to + '-link').text(this.capitalizeFirstLetter(toggle_to));
}

RecordPublisher.prototype.capitalizeFirstLetter = function(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

RecordPublisher.prototype.hideErrorDiv = function() {
  this.errorDiv.addClass('hidden');
}

RecordPublisher.prototype.appendErrorDiv = function() {
  this.errorDiv = $('<div>').addClass('alert alert-dismissible alert-danger hidden');
  $('header').after(this.errorDiv);
}

RecordPublisher.prototype.attachActionHandlers = function() {
  this.actionsContainer.on("click", this.publishLinkAttribute, this.publishAjaxRequest.bind(this));
  this.actionsContainer.on("click", this.unpublishLinkAttribute, this.unpublishAjaxRequest.bind(this));
};

RecordPublisher.prototype.init = function() {
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

    recordPublisher = new RecordPublisher(options);
  recordPublisher.init();
});
