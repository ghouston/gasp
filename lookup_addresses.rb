require 'csv'
require 'fileutils'
require 'logger'
require 'mechanize'

HOMEPAGE_URL = 'http://eringcapture.jccal.org/caportal/CAPortal_MainPage.aspx'
LOG_FILE = 'source_data/mech.log'

class LookupAddresses

# HidParcelNo	22 00 13 3 001 022.000
# HiddenVal	
# NextRecord	1
# Search	Search
# SearchRadio	SearchByParcel
# SearchText	2200133001022000
# TaxYear	2013
# __EVENTARGUMENT	
# __EVENTTARGET	
# __EVENTVALIDATION	/wEWEQLW97XbDQKWx8+MCwLso+WyAwLA0Iu2DwKWxtDsDgKn2pL8CQLsl6iVBgKvqdqmCQKc3cbdCgKvyYXDAwLs3qrIAwLs3salCwLs3tKCAgLs3u7fCQKH59zGDgKH5+ijBgKH58RKuwI+Z0cvOpABPd6zW9TaBinpVnU=
# __LASTFOCUS	
# __VIEWSTATE	/wEPDwUKMTI5MjYxMzM4MQ9kFgICAQ9kFgoCAw8PZBYCHgdPbktleVVwBRJPblBhcmNlbE51bUtleVVwKClkAgUPDxYCHgRUZXh0BQlMQVNUIE5BTUVkZAIJDxBkDxYHZgIBAgICAwIEAgUCBhYHEAUEMjAxMwUEMjAxM2cQBQQyMDEyBQQyMDEyZxAFBDIwMTEFBDIwMTFnEAUEMjAxMAUEMjAxMGcQBQQyMDA5BQQyMDA5ZxAFBDIwMDgFBDIwMDhnEAUEMjAwNwUEMjAwN2dkZAIKDw8WBB8BBRg8Yj5ObyBSZWNvcmRzIEZvdW5kLjwvYj4eB1Zpc2libGVoZGQCCw8WAh8CaBYIAgEPFgIfAmhkAgMPFgIfAmhkAgUPFgIfAmhkAgcPFgIfAmhkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYDBQxTZWFyY2hCeU5hbWUFDlNlYXJjaEJ5UGFyY2VsBQ9TZWFyY2hCeUFkZHJlc3MB8TJvE14tbH7OyfrRLlk9WcYm7A==

	def main
		@agent = Mechanize.new
		FileUtils.rm( LOG_FILE )
		@agent.log = Logger.new( LOG_FILE )  

		CSV.foreach('source_data/small.csv') do |row|
		  # page = homepage()
			# pp page
			# break

			property_search()
		end
	end

  def property_search
		page = @agent.get('http://eringcapture.jccal.org/caportal/CA_PropertyTaxSearch.aspx')
		form = page.form("thisForm")
		form.field_with(:name => "HidParcelNo").value = '22 00 13 3 001 022.000'
		form.field_with(:name => "HiddenVal").value = ''
		form.field_with(:name => "NextRecord").value = '1'
		# form.field_with(:name => "SearchRadio").value = 'SearchByParcel'
		form.field_with(:name => "SearchText").value = '2200133001022000'
		form.field_with(:name => "TaxYear").value = '2013'
		buttons = form.radiobuttons.select { |b| b.value == "SearchByParcel" }
		buttons.first.check

		buttons = form.buttons.select { |b| b.name == "Search" }
		button = buttons.first

		page = @agent.submit(form,button)

		doc = Nokogiri::HTML(page.content)
		state = :looking
		doc.xpath("//table[@id='BodyTable']//td//td").each do |td|
			if state == :looking
				state = :found if td.text =~ /ADDRESS/i
			elsif state == :found
				data = td.text.split(/[\r\n\u00a0]+/m)
				data.each { |t| t.strip! }
				data = data.select { |t| t.length > 0 }
				pp data
				state = :looking
			end
		end
  end

	def homepage
		page = @agent.get(HOMEPAGE_URL)
		form = page.form("thisForm")
		buttons = form.buttons.select { |b| b.name == "PropertyTaxBttn" }
	  button = buttons.first
	  
	  @agent.submit(form,button)
	end
end

LookupAddresses.new.main

