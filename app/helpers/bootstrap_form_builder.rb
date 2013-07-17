# Helper para la construccion de formularios conformes
# al estilo de bootstrap
class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
 
  def text_field(method, options={})
    t = @template
    t.content_tag(:div, :class => "control-group#{' error' unless @object.errors[method].blank?}") {
      t.concat(t.label_tag method, nil, :class => "control-label")
      t.concat(t.content_tag(:div, :class => "controls") {
        t.concat(super method, options)
        if @object.errors[method].present?
          t.concat(t.content_tag(:span, @object.errors[method].last, :class => 'help-inline'))
        end
        })
    }
  end

  def password_field(method, options={})
    t = @template
    t.content_tag(:div, :class => "control-group#{' error' unless @object.errors[method].blank?}") {
      t.concat(t.label_tag method, nil, :class => "control-label")
      t.concat(t.content_tag(:div, :class => "controls") {
        t.concat(super method, options)
        if @object.errors[method].present?
          t.concat(t.content_tag(:span, @object.errors[method].last, :class => 'help-inline'))
        end
        })
    }
  end
end