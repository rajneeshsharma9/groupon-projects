ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |element|
    if element.node_name.eql? 'label'
      html = %(<div class="control-group error">#{element}</div>).html_safe
    elsif form_fields.include? element.node_name
      if instance.error_message.kind_of?(Array)
        html = %(<div class="control-group error">#{html_tag}<span class="form-error">&nbsp;#{instance.error_message.uniq.join(', ')}</span></div>).html_safe
      else
        html = %(<div class="control-group error">#{html_tag}<span class="form-error">&nbsp;#{instance.error_message}</span></div>).html_safe
      end
    end
  end
  
  html

end
