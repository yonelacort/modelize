# encoding: UTF-8

module Modelize
  module God
    module_function

    def create(source, options = {})
      hash_data = Transformer.new(source, options).to_hash
      Instantiator.magic(hash_data, options[:class])
    end
  end
end
