# encoding: UTF-8

require "json"
require "nori"
require "nokogiri"
require "csv"

module Modelize
  class Transformer
    def initialize(source, options = {})
      @source = source
      @format = options[:format]
      @file   = options[:file]
      @separator = options[:separator] || ","
    end

    def to_hash
      begin
        return @source if is_hash?
        data_to_hash
      rescue
        raise MalformedFileError
      end
    end

    private

    def data_to_hash
      if is_xml_file?
        hash_from_xml_file
      elsif is_csv_file?
        hash_from_csv_file
      elsif is_json_file?
        hash_from_json_file
      elsif is_json?
        JSON.parse(@source)
      end
    end

    def hash_from_xml_file
      Nori.new.parse(File.read(@source))
    end

    def hash_from_csv_file
      data = []
      CSV.foreach(@source, headers: true, col_sep: @separator) do |row|
        data << row.to_hash
      end
      data
    end

    def hash_from_json_file
      JSON.parse(File.read(@source))
    end

    def is_hash?
      @format == :hash
    end

    def is_json?
      @format == :json
    end

    def is_json_file?
      @file && is_json?
    end

    def is_csv_file?
      @file && @format == :csv
    end

    def is_xml_file?
      @file && @format == :xml
    end
  end
end