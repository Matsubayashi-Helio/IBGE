require 'csv'
require 'byebug'

class CsvFile 

    def self.import(file)
        hash_csv = []
        CSV.foreach(file, headers: true) do |row|
            hash_csv << row.to_hash
        end
        return hash_csv
    end

end