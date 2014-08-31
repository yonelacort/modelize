module Modelize
  module God
    module_function

    def create(source, options = {})
      hash_data = Transformer.new(source, options).to_hash
      Instantiator.magic(hash_data)
    end
  end
end
