require "has_parents/parent_collection"
require "has_parents/controller_extensions"

ActionController::Base.send(:include, HasParents::ControllerExtensions)