require 'csv'

$ids = []

class LookingForCv
	def handle( row )
		if row[0] =~ /CV[0-9]+/
			FoundCv.new
		else
			self
		end
	end
end

class FoundCv
	def handle( row )
		puts row[0]
		$ids << row[0]
		LookingForCv.new
  end
end

state = LookingForCv.new

CSV.foreach("source_data/2013MarchresultsEXCEL_Gregcvs.csv") do |row|
	state = state.handle(row)  
end

#puts $ids.join(",")
#puts $ids.count
