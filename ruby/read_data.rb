# read in
# two lines as file format example...

#5825 Origin Clothing, 38 Sanger St, Corowa, NSW, 2646
#5826 Taburna Pty Ltd, 38 Oxley St, Bourke, NSW, 2840

def read_data stream=STDIN
	data = {}
	stream.each do |line|
		# line =~ /^([0-9]*)\|(.*)/;
		# id, name_addr = $1.to_i, $2
		splitted = line.split("|")
		id, addr, street_name, city, zipcode, censal_code = splitted
		id = id.to_i

		raise "duplicate id #{id}?" if data[id]
		data[id] = {"addr" => addr, "street_name" => street_name, "city" => city, "zipcode" => zipcode, "censal_code" => censal_code.strip}
	end
	data
end
