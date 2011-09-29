Div Form Builder
================

Rails form builder with internationalization, inline error messages, possiblity to display previous
field value, and configurable markup.

Usage
-----

1) Install the plugin to your application:

    ./script/plugin install git://github.com/dekart/div_form_builder.git

2) Profit! :) Now every form_for tag will use DivFormBuilder by default:

    <% form_for @post do |form| %>
      <%= form.text_field :title %>
      <%= form.text_area  :content %>
      <%= form.check_box :publish %>
      <%= form.datetime_select :published_at %>
      <%= form.select :category_id, Category.all.collect{|c| [c.name, c.id] } %>
      <%= form.radio_button :visibility, [["All", :all], ["Friends", :friends], ["Private", :private]] %>

      <%= form.submit %>
    <% end %>

Usage Details
-------------

DivFormBuilder provides you with additional field options that can be useful to make your forms reacher.

Mark required fields:

    <% form_for @post do |form| %>
      <%= form.text_field :title, :required => true %>
      <%= form.text_area  :content %>
    <% end %>

Move your fields to a separate partial:

    <% form_for @post do |form| %>
      <%= form.fields %> - will include "form_fields" partial by default
      <%= form.fields "path/to/custom/partial" %>
    <% end %>

Set custom label (human_attribute_name is used by default) or disable label at all:

    <% form_for @post do |form| %>
      <%= form.text_field :title, :required => true, :label => "Post Title" %>
      <%= form.text_area  :content, :label => false %>
    <% end %>

Add something before and after input wrapper:

    <% form_for @post do |form| %>
      <%= form.text_area :content, :before_field => "Some text", :after_field => "Other text" %>
    <% end %>

Add comment:

    <% form_for @post do |form| %>
      <%= form.text_area :content, :comment => "Some comment" %>
    <% end %>

Display previous field values:

    <% form_for @post, :show_changes => true do |form| %>
      <%= form.text_field :title %>
    <% end %>

Disable field wrapper:

    <% form_for @post do |form| %>
      <%= form.text_area :content, :wrapper => false %>
    <% end %>


Testing
-------

No tests yet :( You can fork this plugin at GitHub (http://github.com/dekart/div_form_builder)
and add your own tests. I'll be happy to accept patches!

Installing the plugin
------------------

    ./script/plugin install git://github.com/dekart/div_form_builder.git

Credits
-------

Written by [Alex Dmitriev](http://railorz.ru)
