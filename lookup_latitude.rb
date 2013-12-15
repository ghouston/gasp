require 'csv'
require 'fileutils'
require 'logger'
require 'mechanize'
require 'open-uri'
require 'pp'

LOG_FILE = 'data/mechanize.log'


class LookupLatitude
  def main
    setup_mechanize  

    CSV.new(ARGF).each do |row|
      latitude, longitude = lookup_latitude(row[2])
      row << latitude
      row << longitude
      puts row.to_csv
      sleep(0.5)
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

  def lookup_latitude(address)
    return ["",""] if address.eql? ""

    url="http://maps.googleapis.com/maps/api/geocode/json?address=#{URI::encode(address)}&sensor=false"
    result = @agent.get(url)
    json_parser = JSON::Ext::Parser.new(result.content)
    json = json_parser.parse
    lat_and_lng = [ json["results"][0]['geometry']['location']['lat'], json["results"][0]['geometry']['location']['lng'] ]
  end

end

LookupLatitude.new.main
