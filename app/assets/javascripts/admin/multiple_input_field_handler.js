function MultipleInputFieldHandler(options) {
  this.button = options.button;
  this.container = options.container;
  this.hiddenInputDiv = options.hiddenInputDiv;
}

MultipleInputFieldHandler.prototype.addInputFieldToContainer = function() {
  var inputDiv = this.hiddenInputDiv.clone().removeClass("hidden-input-div"),
      _this = this;
  inputDiv.find("[data-type='add-more-field']").each(function(index, input) {
    $input = $(input);
    $input.attr('name', _this.returnNameFieldValue($input));
  });
  this.container.append(inputDiv);
}

MultipleInputFieldHandler.prototype.returnNameFieldValue = function(input) {
  return input.data("model") + '[' + input.data("association") + '][' + $.now() + ']';
}

MultipleInputFieldHandler.prototype.addButtonClickHandler = function(event) {
  this.addInputFieldToContainer();
}


MultipleInputFieldHandler.prototype.attachAddButtonHandler = function() {
  this.button.on("click", this.addButtonClickHandler.bind(this));
};

MultipleInputFieldHandler.prototype.init = function() {
  this.attachAddButtonHandler();
};

$(document).ready(function() {
  var options = {
    "button" : $("[data-type='add-more-images-container'").find("[data-type='add-more-button']"),
    "hiddenInputDiv" : $("[data-type='add-more-images-container'").find("[data-type='hidden-input-div']"),
    "container" : $("[data-type='add-more-images-container'").find("[data-type='add-more-container']")
  },

    handler = new MultipleInputFieldHandler(options);
  handler.init();
});
