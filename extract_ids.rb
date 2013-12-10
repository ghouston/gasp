require 'csv'

# reads a CSV file from disk or *nix pipe
# writes all property ids out (e.g. all 18 digit numbers found)

def main
	ARGF.each_line do |line|
		row = CSV.parse_line line
		puts row[0] if row[0] =~ /[0-9]{18}/
	end
end

main()
