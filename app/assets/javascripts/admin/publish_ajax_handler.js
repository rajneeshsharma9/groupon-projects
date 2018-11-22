function PublishAjaxHandler(options) {
  this.actionsContainer = options.actionsContainer;
  this.publishLinkAttribute = options.publishLinkAttribute;
  this.unpublishLinkAttribute = options.unpublishLinkAttribute;
}

PublishAjaxHandler.prototype.publishAjaxRequest = function(event) {
  event.preventDefault();
  $.ajax({
    url: $(event.target).attr('data-publish-url'),
    type: 'PUT',
    data:  JSON.stringify({ id: $(event.target).attr('data-id') }),
    contentType: 'application/json',
    dataType: 'json',
    error: function(XMLHttpRequest, errorTextStatus, error) {
      console.log("Failed: " + errorTextStatus + " ;" + error);
    },
    success: function(dealJson) {
      $("[data-type='deal-date'][data-id='" + $(event.target).attr('data-id') + "']").html(dealJson.published_at);
      $(event.target).attr("data-type", 'unpublish-link').text('Unpublish');
    }
  });
}

PublishAjaxHandler.prototype.unpublishAjaxRequest = function(event) {
  event.preventDefault();
  $.ajax({
    url: $(event.target).attr('data-unpublish-url'),
    type: 'PUT',
    data:  JSON.stringify({ id: $(event.target).attr('data-id') }),
    contentType: 'application/json',
    dataType: 'json',
    error: function(XMLHttpRequest, errorTextStatus, error) {
      console.log("Failed: " + errorTextStatus + " ;" + error);
    },
    success: function(data) {
      $("[data-type='deal-date'][data-id='" + $(event.target).attr('data-id') + "']").html('-');
      $(event.target).attr("data-type", 'publish-link').text('Publish');
    }
  });
}

PublishAjaxHandler.prototype.attachActionHandlers = function() {
  this.actionsContainer.on("click", this.publishLinkAttribute, this.publishAjaxRequest.bind(this));
  this.actionsContainer.on("click", this.unpublishLinkAttribute, this.unpublishAjaxRequest.bind(this));
};

PublishAjaxHandler.prototype.init = function() {
  this.attachActionHandlers();
};

$(document).ready(function() {
  var options = {
    "actionsContainer" : $("[data-type='actions-container']"),
    "publishLinkAttribute" : "[data-type='publish-link']",
    "unpublishLinkAttribute" : "[data-type='unpublish-link']"
  },

    publishAjaxHandler = new PublishAjaxHandler(options);
  publishAjaxHandler.init();
});
