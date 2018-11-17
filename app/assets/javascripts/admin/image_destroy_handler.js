function ImageDestroyHandler(options) {
  this.destroy_button = options.destroy_button;
}

ImageDestroyHandler.prototype.destroyButtonClickHandler = function(event) {
  $(event.target).siblings('img').toggleClass('greyImage');
}

ImageDestroyHandler.prototype.attachDestroyButtonHandler = function() {
  this.destroy_button.on("click", this.destroyButtonClickHandler.bind(this));
};

ImageDestroyHandler.prototype.init = function() {
  this.attachDestroyButtonHandler();
};

$(document).ready(function() {
  var options = {
    "destroy_button" : $(".css-label")
  },

    imageHandler = new ImageDestroyHandler(options);
  imageHandler.init();
});
