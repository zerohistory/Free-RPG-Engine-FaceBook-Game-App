require 'will_paginate'

module WallPostsHelper
  class PaginationRenderer < WillPaginate::LinkRenderer
    def page_link(page, text, attributes = {})
      @template.link_to_remote(text,
        :url    => @template.send(:character_wall_posts_path, @collection.first.character, :page => page),
        :method => :get,
        :update => :ajax,
        :html   => attributes
      )
    end
  end
end
