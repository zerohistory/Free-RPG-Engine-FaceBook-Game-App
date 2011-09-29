I18n.load_path << Dir[File.join(File.dirname(__FILE__), "config", "locales", "*.yml")]

ActionView::Base.send(:include, GroupedSelectTag::ActionViewExtension)
ActionView::Helpers::InstanceTag.send(:include, GroupedSelectTag::InstanceTagExtension)

ActionView::Base.default_form_builder = DivFormBuilder
