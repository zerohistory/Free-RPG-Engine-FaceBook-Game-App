module FacebookPaginator
  class TemplateProxy
    def initialize(template)
      @template = template
    end

    def params
      unless @params
        @params = HashWithIndifferentAccess.new

        @template.params.each_pair do |key, value|
          @params[key] = value unless key.to_s.starts_with?("fb_sig")
        end
      end

      @params
    end

    def method_missing(*args)
      @template.send(*args)
    end
  end

  class LinkRenderer < WillPaginate::LinkRenderer
    def prepare(collection, options, template)
      super(collection, options, TemplateProxy.new(template))
    end
  end
end
