function MultipleInputFieldHandler(options) {
  this.button = options.button;
  this.container = options.container;
  this.hiddenInputDiv = options.hiddenInputDiv;
}

MultipleInputFieldHandler.prototype.addInputFieldToContainer = function() {
  var inputDiv = this.hiddenInputDiv.clone().removeClass("hidden-input-div"),
      _this = this,
      currentTimeStamp = $.now();
  inputDiv.find("[data-type='add-more-field']").each(function(index, input) {
    $input = $(input);
    $input.attr('name', _this.returnNameFieldValue($input, _this.currentTimeStamp));
  });
  this.container.append(inputDiv);
}

MultipleInputFieldHandler.prototype.returnNameFieldValue = function(input, currentTimeStamp) {
  return input.data("model") + '[' + input.data("association") + '][' + currentTimeStamp + ']';
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
  var addMoreContainer = $("[data-type='add-more-images-container'");
  var options = {
    "button" : addMoreContainer.find("[data-type='add-more-button']"),
    "hiddenInputDiv" : addMoreContainer.find("[data-type='hidden-input-div']"),
    "container" : addMoreContainer.find("[data-type='add-more-container']")
  },

    handler = new MultipleInputFieldHandler(options);
  handler.init();
});
