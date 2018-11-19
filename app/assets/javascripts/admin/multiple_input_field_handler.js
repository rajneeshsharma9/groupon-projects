function MultipleInputFieldHandler(options) {
  this.button = options.button;
  this.container = options.container;
  this.hidden_input_div = options.hidden_input_div;
}

MultipleInputFieldHandler.prototype.addInputFieldToContainer = function() {
  var inputDiv = this.hidden_input_div.clone();
      _this = this;
  inputDiv.find('input').each(function(index, input) {
    $input = $(input);
    $input.attr('name', _this.returnNameFieldValue($input));
    _this.container.append($input);
  });
}

MultipleInputFieldHandler.prototype.returnNameFieldValue = function(input) {
  return input.data("model") + '[' + input.data("for") + '][' + $.now() + ']';
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
    "button" : $("[data-type='add-more-button']"),
    "hidden_input_div" : $("[data-type='hidden-input-div']"),
    "container" : $("[data-type='add-more-container']")
  },

    handler = new MultipleInputFieldHandler(options);
  handler.init();
});
