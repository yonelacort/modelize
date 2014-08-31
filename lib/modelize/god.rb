module Modelize
  class God
    def initialize(data, options = {})
      @data   = data
      @options = options
    end

    def create
      hash_data = Transformer.new(@data, @options).to_hash
      Instantiator.magic(hash_data)
    end
  end
end
