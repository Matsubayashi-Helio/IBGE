# frozen_string_literal: true

require 'csv'
require 'byebug'

class CsvFile
  def self.import(file)
    hash_csv = []
    CSV.foreach(file, headers: true) do |row|
      hash_csv << row.to_hash
    end
    hash_csv
  end
end
