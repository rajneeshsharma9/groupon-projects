function ImageDestroyHandler(options) {
  this.destroyButton = options.destroyButton;
}

ImageDestroyHandler.prototype.destroyButtonClickHandler = function(event) {
  $(event.target).siblings('img').toggleClass('greyImage');
}

ImageDestroyHandler.prototype.attachDestroyButtonHandler = function() {
  this.destroyButton.on("click", this.destroyButtonClickHandler.bind(this));
};

ImageDestroyHandler.prototype.init = function() {
  this.attachDestroyButtonHandler();
};

$(document).ready(function() {
  var options = {
    "destroyButton" : $("[data-type='image-label']")
  },

    imageHandler = new ImageDestroyHandler(options);
  imageHandler.init();
});
