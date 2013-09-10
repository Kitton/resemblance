#!/usr/bin/env ruby
# encoding: utf-8
raise "usage: make_db.rb SKETCH_SIZE N_GRAM_LEN SHINGLE_MODE(-w/-c)" unless ARGV.length == 3 and (ARGV[2].to_s == "-w" or ARGV[2].to_s == "-c")

SKETCH_SIZE = ARGV[0].to_i
N_GRAM_LEN = ARGV[1].to_i
SHINGLE_MODE = ARGV[2].to_s

require 'set'
require 'mongo'
include Mongo

require File.dirname(__FILE__)+'/read_data'
require File.dirname(__FILE__)+'/sketching'
require File.dirname(__FILE__)+'/shingling'

alias _puts puts
def puts msg
	_puts "#{Time.now} #{msg}"
end

MongoClient.new.drop_database("Sketching")
db = MongoClient.new.db("Sketching")
coll = db["Parameters"]
doc = {"SKETCH_SIZE" => SKETCH_SIZE, "N_GRAM_LEN" =>N_GRAM_LEN, "SHINGLE_MODE" => SHINGLE_MODE}
coll.insert(doc)

documents = read_data
puts "documents are read"

coll = db["Documents"]
documents.each do |id, text|
	doc = {"_id" => id, "Doc_text" => text}
	coll.insert(doc)
end
puts "Docs are inserted"

# sketches_with_ids = {}
coll = db["Sketches"]
coll.create_index("sketch")

documents.each do |id, text|
	puts id if ( (id % 20000) == 0)
	doc_shingles = text.shingles
	sketches = Sketch.new(doc_shingles).apply_hash 
	sketches.each do |sk|
		doc = coll.find_one("sketch" => sk.to_s)
		if doc.nil?
			new_doc = {"sketch" => sk.to_s, "doc_ids" => [id]}
			coll.insert(new_doc)
		else
			coll.update({"sketch" => sk.to_s}, {"$addToSet" => {"doc_ids" => id}})
		end
		# sketches_with_ids[sk] ||= Set.new
		# sketches_with_ids[sk] << id
	end
end

# sketches_with_ids.each do |sk, ids|
# 	doc = {"sketch" => sk.to_s, "doc_ids" => ids.to_a}
# 	coll.insert(doc)
# end


# document_ids = [] # mapping from idx in arrays to document id read from data file
# document_shingles = documents.collect do |id_text|
# 	id,text = id_text
# 	document_ids << id
# 	text.shingles
# end

# puts "Shingles are created"

# sketches = Sketches.calculate_for document_shingles
# puts "Sketches are calculated"

# # build < xid, di > list and convert into hash xi -> ids_of_those_with_xi
# x_to_i = {}
# sketches.each_with_index do |s,i|
# 	p s.inspect if s.sketch.nil?
# 	s.sketch.each do |sk|
# 		x_to_i[sk] ||= Set.new
# 		x_to_i[sk] << document_ids[i]
# 	end
# end

# MongoClient.new.drop_database("Sketching")
# db = MongoClient.new.db("Sketching")

# #Save Parameters
# coll = db["Parameters"]
# doc = {"SKETCH_SIZE" => SKETCH_SIZE, "N_GRAM_LEN" =>N_GRAM_LEN, "SHINGLE_MODE" => SHINGLE_MODE}
# coll.insert(doc)

# coll = db["Documents"]

# documents.each do |id, text|
# 	doc = {"_id" => id, "Doc_text" => text}
# 	coll.insert(doc)
# end

# puts "Documents are inserted"

# coll = db["Sketches"]
# x_to_i.each do |sketch, doc_ids|
# 	doc = {"sketch" => sketch.to_s, "doc_ids" => doc_ids.to_a}
# 	coll.insert(doc)
# end

puts "<--- end time"