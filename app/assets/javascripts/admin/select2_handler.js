function Select2Handler(options) {
  this.selectField = options.selectField;
}

Select2Handler.prototype.init = function() {
  this.selectField.select2({
  });
};

$(document).ready(function() {
  var options = {
    "selectField" : $("[data-type='select2-enabled']"),
  },

    selectHandler = new Select2Handler(options);
  selectHandler.init();
});
