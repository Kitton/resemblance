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

db = MongoClient.new.db("Sketching")
coll = db["Parameters"]
coll.remove
doc = {"SKETCH_SIZE" => SKETCH_SIZE, "N_GRAM_LEN" =>N_GRAM_LEN, "SHINGLE_MODE" => SHINGLE_MODE}
coll.insert(doc)

documents = read_data
puts "documents are read"

# coll = db["Documents"]
# coll.remove
# documents.each do |id, e|
# 	doc = e
# 	doc["_id"] = id
# 	coll.insert(doc)
# end
# puts "Docs are inserted"
# abort

coll = db["Sketches"]
coll.remove
coll.create_index("sketch")

documents.each do |id, e|
	puts id if ( (id % 10000) == 0)
	text = e["addr"]
	doc_shingles = text.shingles(SHINGLE_MODE, N_GRAM_LEN)
	sketches = Sketch.new(doc_shingles).apply_hash(SKETCH_SIZE)
	sketches.each do |sk|
		doc = coll.find_one("sketch" => sk.to_s)
		if doc.nil?
			new_doc = {"sketch" => sk.to_s, "doc_ids" => [id]}
			coll.insert(new_doc)
		else
			# coll.update({"sketch" => sk.to_s}, {"$push" => {"doc_ids" => id}})
			coll.update({"sketch" => sk.to_s}, {"$addToSet" => {"doc_ids" => id}})
		end
	end
end

puts "<--- end time"