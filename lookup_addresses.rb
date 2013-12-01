require 'mechanize'
require 'csv'

CSV.foreach("source_data.csv") do |row|
  puts row[0]

	agent = Mechanize.new
	page = agent.get('http://google.com/')
	google_form = page.form('f')
	google_form.q = 'ruby mechanize'
	page = agent.submit(google_form)
	pp page

end
