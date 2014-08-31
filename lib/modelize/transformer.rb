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
      @data = data_to_json if is_csv?
      @data = JSON.parse(@data) if is_json_string?
      # raise UnsupportedFormat if @data.nil?
      @data
    end

    private

    def data_to_json
      if is_xml?
        json_from_xml
      elsif is_csv?
        json_from_csv_file
      end
    end

    def json_from_xml
      Hash.from_xml(@obect).to_json
    end

    def json_from_csv_file
      data = []
      CSV.foreach(@data, headers: true, col_sep: @separator) do |row|
        data << row.to_hash
      end
      data
    end

    def is_json_string?
      @format == :json_string
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