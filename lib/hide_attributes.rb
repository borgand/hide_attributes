module HideAttributes #:nodoc:
  module ClassMethods

    # Macro to specify which attributes are to be hidden
    #
    #   hide_attributes :password, :password_salt
    def hide_attributes(*arr)
      @hidden_attributes = arr.flatten
    end
    attr_reader :hidden_attributes
  end

  # Merge +to_xml+ options with +:exclude => hidden_attributes+
  def to_xml_with_hidden(opts=nil, &block)
    merge_options_and_call(:to_xml_without_hidden, opts, block)
  end

  # Merge +as_json+ with +:exclude => hidden_attributes+
  def to_json_with_hidden(opts=nil)
    merge_options_and_call(:to_json_without_hidden, opts)
  end

  # Hook up class methods and aliases
  def self.included(base)
    base.extend(ClassMethods)
    base.alias_method_chain :to_xml, :hidden
    base.alias_method_chain :to_json, :hidden
  end

  private
  # Merge options with +:exclude => hidden_attributes+ and call indicated formatter
  def merge_options_and_call(formatter, opts=nil, &block)
    opts ||= {}
    send(formatter, {:except => self.class.hidden_attributes}.merge(opts), block)
  end
end
