#!/usr/bin/env ruby
# encoding: utf-8

raise "usage: find_similar.rb SIMILARITY_PERCENTAGE=[0..1]" unless ARGV.length == 1
SIMILARITY_PERCENTAGE = ARGV[0].to_f

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
parameters = coll.find_one()
SKETCH_SIZE = parameters["SKETCH_SIZE"]
N_GRAM_LEN = parameters["N_GRAM_LEN"]

documents = read_data

document_ids = [] # mapping from idx in arrays to document id read from data file
document_shingles = documents.collect do |id_text|
	id,text = id_text
	document_ids << id
	text.shingles
end

sketches = Sketches.calculate_for document_shingles
# sketches = Sketches.calculate_for_all document_shingles
sketches = sketches.collect{|s| s.sketch}
sketches.flatten!
p "sketches.size = #{sketches.size}"

coll = db["Sketches"]

similar_docs = {}
similar_docs.default = 0

sketches.each do |s|
	doc = coll.find_one("sketch" => s.to_s)
	next if doc.nil?
	doc["doc_ids"].each {|e| similar_docs[e] += 1}
end

p similar_docs
near_duplicates = []
SKETCH_SIZE = similar_docs.values.max
similar_docs.each {|k,v| near_duplicates << k if v >= SKETCH_SIZE*SIMILARITY_PERCENTAGE}
p near_duplicates
p near_duplicates.size