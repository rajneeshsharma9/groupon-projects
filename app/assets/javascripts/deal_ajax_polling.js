function AjaxPollingHandler(options) {
  this.container = options.container;
  this.ajaxRequestInterval = options.ajaxRequestInterval;
  this.soldProgressContainer = options.soldProgressContainer;
  this.requestUrl = options.container.attr('data-ajax-url');
}

AjaxPollingHandler.prototype.sendAjaxRequest = function() {
  _this = this;
  $.ajax({
    url: _this.requestUrl,
    type: 'GET',
    data: { currrent_quantity_sold: _this.container.text() },
    dataType: 'json',
    error: function(XMLHttpRequest) {
      console.log($.parseJSON(XMLHttpRequest.responseText));
    },
    success: function(dealJson) {
      _this.updateContentText(dealJson.quantity_sold, dealJson.percentage_sold);
    }
  });
}

AjaxPollingHandler.prototype.updateContentText = function(quantity_sold, percentage_sold) {
  this.container.text(quantity_sold);
  this.soldProgressContainer.css('width', percentage_sold + '%');
};

AjaxPollingHandler.prototype.init = function() {
  setInterval(this.sendAjaxRequest.bind(this), this.ajaxRequestInterval);
};

$(document).ready(function() {
  var options = {
    "container" : $("[data-container='ajax-polling']"),
    "soldProgressContainer" : $("[data-container='sold-progress']"),
    "ajaxRequestInterval" : 30000
  },

    ajaxPollingHandler = new AjaxPollingHandler(options);
  ajaxPollingHandler.init();
});
