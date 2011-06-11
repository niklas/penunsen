#require 'inherited_resources/helpers'

Minimal::Template::FormBuilderProxy::PROXY_TAGS << :simple_form_for << :simple_fields_for
Minimal::Template.class_eval do
  include Minimal::Template::FormBuilderProxy
  include Minimal::Template::TranslatedTags
  #include InheritedResources::Helpers::LinkTo
end
ActionView::Template.register_template_handler('rb', Minimal::Template::Handler)
