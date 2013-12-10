require 'csv'
require 'fileutils'
require 'logger'
require 'mechanize'
require 'open-uri'

LOG_FILE = 'data/mechanize.log'

# reads the input csv file or *nix pipe which contains property ids
# looks up the property on Jefferson County's website for 2013 tax year
# writes the property_id, owner, property_location in csv format
class LookupAddresses
  def main
    setup_mechanize  

    CSV.new(ARGF).each do |row|
      property_search(row[0])
    end
  end

  def setup_mechanize
    @agent = Mechanize.new
    FileUtils.remove_file( LOG_FILE, force = true )
    @agent.log = Logger.new( LOG_FILE )
  end

  # format_parcel_id("2200133001022000") #=> '22 00 13 3 001 022.000'
  def format_parcel_id(pid)
    "#{pid[0..1]} #{pid[2..3]} #{pid[4..5]} #{pid[6]} #{pid[7..9]} #{pid[10..12]}.#{pid[13..15]}"
  end

  def property_search(original_property_id)
    pid = original_property_id[2..-1]

    url = "http://eringcapture.jccal.org/caportal/CA_PropertyTaxParcelNavigation.aspx?ParcelNo=#{URI::encode(format_parcel_id(pid))}&RecordYear=2013"
    page = @agent.get(url)

    owner,location = parse_page(page)
    puts [original_property_id,owner,location].to_csv
  end

  def parse_page(page)
    owner = location = "NOT_FOUND"
    doc = Nokogiri::HTML(page.content)
    state = :looking
    doc.xpath("//tr/td").each do |td|
      if state == :looking
        if td.children.count == 1 && td.text =~ /LOCATION/i
          state = :found_location
        elsif td.children.count == 3 && td.text =~ /OWNER/i
          state = :found_owner
        end
      elsif state == :found_location
        location = cleanup(td.text)
        state = :looking
      elsif state == :found_owner
        owner = cleanup(td.text)
        state = :looking
      else
        raise "UNKNOWN STATE: #{state}"
      end
    end
    [owner, location]
  end

  def cleanup(raw_text)
    data = raw_text.split(/[\r\n\u00a0]+/m) # newlines and non-breaking spaces
    data = data.each { |t| t.strip! }
    data = data.select { |t| t.length > 0 }
    data = data.join(', ')
    data
  end
end

LookupAddresses.new.main


