#!/usr/bin/env jruby

raise "usage: make_db.rb SKETCH_SIZE N_GRAM_LEN" unless ARGV.length == 2

SKETCH_SIZE = ARGV[0].to_i
N_GRAM_LEN = ARGV[1].to_i

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

documents = read_data

document_ids = [] # mapping from idx in arrays to document id read from data file
document_shingles = documents.collect do |id_text|
	id,text = id_text
	document_ids << id
	text.shingles
end

puts "Shingles are created"

sketches = Sketches.calculate_for document_shingles
puts "Sketches are calculated"

# build < xid, di > list and convert into hash xi -> ids_of_those_with_xi
x_to_i = {}
sketches.each_with_index do |s,i|
	s.sketch.each do |sk|
		x_to_i[sk] ||= Set.new
		x_to_i[sk] << i
	end
end

MongoClient.new.drop_database("Sketching")
db = MongoClient.new.db("Sketching")

#Save Parameters
coll = db["Parameters"]
doc = {"SKETCH_SIZE" => SKETCH_SIZE, "N_GRAM_LEN" =>N_GRAM_LEN}
coll.insert(doc)

coll = db["Documents"]

documents.each do |id, text|
	doc = {"_id" => id, "Doc_text" => text}
	coll.insert(doc)
end

puts "Documents are inserted"

coll = db["Sketches"]
x_to_i.each do |sketch, doc_ids|
	doc = {"_id" => sketch, "doc_ids" => doc_ids.to_a}
	coll.insert(doc)
end