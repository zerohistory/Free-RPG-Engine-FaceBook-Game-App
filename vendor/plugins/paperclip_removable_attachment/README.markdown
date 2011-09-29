Removable Paperclip Attachments
===============================

Allow easy removal of Paperclip attachments using checkbox in your forms.

Requirements
------------

This plugin depends on [Thoughtbot's Paperclip gem/plugin](http://github.com/thoughtbot/paperclip)

Usage
-----

1) Add removable flag to your attachment definition:

    class User < ActiveRecord::Base
      has_attached_file :avatar,
        :styles     => {:small => "100x100>"},
        :removable  => true

      # If you use attr_accessible to protect your attributes - don't forget to add new attribute
      attr_accessible :remove_avatar
    end

2) Add new checkbox to your form:

    <% form_for @user do |form| %>
      <%= form.label :avatar %>
      <%= form.file_field :avatar %>

      <%= form.label :remove_avatar %>
      <%= form.check_box :remove_avatar %>
    <% end

3) Profit! :)

If the remove_avatar checkbox is checked, attachment will be automatically deleted.
You can also use this flag from your code:

    class UsersController < ApplicationController
      ...

      def remove_avatar
        @user = User.find(params[:id])

        @user.remove_avatar = true
        @user.save
      end
    end

Testing
-------

No tests yet :( You can [fork this plugin at GitHub](http://github.com/dekart/paperclip_removable_attachment)
and add your own tests. I'll be happy to accept patches!

Installing the plugin
------------------

    ./script/plugin install git://github.com/dekart/paperclip_removable_attachment.git

Credits
-------

Written by [Alex Dmitriev](http://railorz.ru)
