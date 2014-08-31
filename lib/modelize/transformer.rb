require "json"
# require "xml"
require "csv"

module Modelize
  class Transformer
    def initialize(data, options = {})
      @data   = data
      @format = options[:format]
      @file   = options[:file]
      @separator = options[:separator] || ","
    end

    def to_hash
      return @data if is_hash?
      @data = data_to_hash
      # raise UnsupportedFormat if @data.nil?
      @data
    end

    private

    def data_to_hash
      if is_xml?
        hash_from_xml
      elsif is_csv?
        hash_from_csv_file
      elsif is_json? && !@file
        JSON.parse(@data)
      elsif is_json? && @file
        hash_from_json_file
      end
    end

    def hash_from_xml
      Hash.from_xml(@obect).to_json
    end

    def hash_from_csv_file
      data = []
      CSV.foreach(@data, headers: true, col_sep: @separator) do |row|
        data << row.to_hash
      end
      data
    end

    def hash_from_json_file
      File.open(@data, "r" ) do |file|
        JSON.load(file)
      end
    end

    def is_json?
      @format == :json
    end

    def is_hash?
      @format == :hash
    end

    def is_csv?
      @file && @format == :csv
    end

    def is_xml?
      @file && @format == :xml
    end
  end
end