function MultipleInputFieldHandler(options) {
  this.button = options.button;
  this.container = options.container;
  this.input_field = options.input_field;
  this.input_model = options.input_model;
  this.input_attribute = options.input_attribute;
}

MultipleInputFieldHandler.prototype.addInputFieldToContainer = function() {
  var input = this.input_field.clone(),
    $input = $(input[0]);
  $input.removeClass('hidden-input').attr('name', this.returnNameFieldValue());
  this.container.append($input);
}

MultipleInputFieldHandler.prototype.returnNameFieldValue = function() {
  return this.input_model + '[' + this.input_attribute + '][' + $.now() + ']';
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
    "input_field" : $("[data-type='add-more-field']"),
    "container" : $("[data-type='add-more-container']"),
    "input_model" : 'deal',
    "input_attribute" : 'images'
  },

    handler = new MultipleInputFieldHandler(options);
  handler.init();
});
