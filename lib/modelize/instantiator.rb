# encoding: UTF-8

require "virtus"

module Modelize
  module Instantiator
    module_function

    def magic(hash_data, klass = nil)
      klass = Class.new unless klass
      klass.class_eval("include Virtus.model")

      if hash_data.class == Array
        set_klass_attributes(klass, hash_data.first)
        hash_data.collect { |element| set_instance_values(klass, element) }.compact
      else
        set_klass_attributes(klass, hash_data)
        set_instance_values(klass, hash_data)
      end
    end

    private

    def self.set_klass_attributes(klass, hash_data)
      hash_data.each { |key, value| klass.class_eval("attribute :#{key}") }
      keys = hash_data.keys.collect { |k| ":#{k}" }.join(",")
      klass.class_eval("attr_accessor #{keys}")
    end

    def self.set_instance_values(klass, hash_data)
      return nil if hash_data.nil?
      attrs = {}
      hash_data.each do |key, value|
        value = magic(value) if value.class == Hash
        attrs[key] = value
      end
      klass.new(attrs)
    end
  end
end