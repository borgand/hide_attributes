require File.join(File.dirname(__FILE__), 'lib', 'hide_attributes.rb')

ActiveRecord::Base.send :include, HideAttributes
