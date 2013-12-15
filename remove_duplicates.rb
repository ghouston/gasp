require 'csv'
require 'fileutils'
require 'logger'
require 'mechanize'
require 'open-uri'
require 'pp'

LOG_FILE = 'data/mechanize.log'


class RemoveDuplicates
  def main
    all_data = []
    CSV.new(ARGF).each do |row|
      all_data << row
    end
	all_data.uniq! { |s| s[2] }
	all_data.each do |row|
		puts row.to_csv
	end
  end
end

RemoveDuplicates.new.main
