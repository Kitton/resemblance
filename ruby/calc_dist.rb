#!/usr/bin/env ruby
# encoding: utf-8

require 'levenshtein'
require File.dirname(__FILE__)+'/read_data'
DATA_FILE = "./toy_test/accounts.txt"

def calc_dist base_index,to_compare
	data = {}
	File.open(DATA_FILE, "r").each do |line|
		line =~ /^([0-9]*)\|(.*)/;
		id, name_addr = $1.to_i, $2
		raise "duplicate id #{id}?" if data[id]
		data[id] = name_addr
	end

	# BASE_INDEX = 405014
	# TO_COMPARE = [402009, 402010, 402011]
	# TO_COMPARE = [8000, 15000, 15001, 15002, 15003, 15004, 15005, 15006, 15007, 38002, 38003, 38004, 38005, 75001, 106000, 106001, 106002, 106003, 106004, 157001, 174000, 174001, 174002, 174003, 272000, 285002, 285003, 285004, 285005, 285006, 285007, 285008, 285009, 285010, 405000, 405001, 405002, 405003, 405004, 405005, 405006, 405007, 405008, 405009, 405010, 405011, 405012, 405013, 405014]
	# TO_COMPARE = [177001,192001,192004,205004,230002,248000,278000,278001,278002,278003,280001,285002,285005,405014]

	documents = read_data
	base_string = data[base_index]

	to_compare.each do |ind|
		dist = Levenshtein.distance(base_string, data[ind])
		p "#{dist} | #{base_index} : #{ind}"
	end
end