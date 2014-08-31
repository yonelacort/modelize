# encoding: UTF-8

require "modelize/version"
require "modelize/transformer"
require "modelize/instantiator"
require "modelize/error"

module Modelize
  module_function

  def create(source, options = {})
    hash_data = Transformer.new(source, options).to_hash
    Instantiator.magic(hash_data, options[:class])
  end
end