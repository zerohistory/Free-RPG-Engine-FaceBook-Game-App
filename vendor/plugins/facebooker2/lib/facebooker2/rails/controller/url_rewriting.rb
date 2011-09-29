module Facebooker2
  module Rails
    module Controller
      module UrlRewriting
        def self.included(base)
          base.alias_method_chain :url_for, :facebooker
        end

        def url_for_with_facebooker(options = {})
          if options.is_a?(Hash)
            if options.delete(:canvas) && !options[:host]
              options[:only_path] = true

              canvas = true
            else
              canvas = false
            end

            url = url_for_without_facebooker(options)

            canvas ? Facebooker2.canvas_page_url + url : url
          else
            url_for_without_facebooker(options)
          end
        end
      end
    end
  end
end
