require 'csv'

def main
	state = LookingForCv.new
	# tried CSV.filter but no way to remove rows in output.
	ARGF.each_line do |line|
		row = CSV.parse_line line
		state = state.handle(row)
	end
end

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
		LookingForCv.new
  end
end

main()

