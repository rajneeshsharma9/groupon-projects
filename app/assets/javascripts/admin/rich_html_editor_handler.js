//= require ck_editor

function RichHtmlEditorHandler(options) {
  this.textarea = options.textarea;
  this.toolbar_options = options.toolbar_options
}

RichHtmlEditorHandler.prototype.createClassicEditor = function() {
  ClassicEditor.create(this.textarea.get(0), {
    toolbar: this.toolbar_options
  })
};

RichHtmlEditorHandler.prototype.init = function() {
  this.createClassicEditor();
};

$(document).ready(function() {
  var options = {
    "textarea" : $("[data-type='ck-editor-textarea']"),
    "toolbar_options" : [ 'heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote' ]
  },

    editor = new RichHtmlEditorHandler(options);
  editor.init();
});
