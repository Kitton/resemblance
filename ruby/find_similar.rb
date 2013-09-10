#!/usr/bin/env ruby
# encoding: utf-8

require 'set'
require 'mongo'
include Mongo

require File.dirname(__FILE__)+'/read_data'
require File.dirname(__FILE__)+'/sketching'
require File.dirname(__FILE__)+'/shingling'
require File.dirname(__FILE__)+'/calc_dist'


alias _puts puts
def puts msg
	_puts "#{Time.now} #{msg}"
end


def find_similar searched_text, similarity_percentage
	db = MongoClient.new.db("Sketching")

	coll = db["Parameters"]
	parameters = coll.find_one()
	p "parameters = #{parameters}"
	sketch_size = parameters["SKETCH_SIZE"]
	n_gram_len = parameters["N_GRAM_LEN"]
	shingle_mode = parameters["SHINGLE_MODE"]

	document_shingles = searched_text.shingles(shingle_mode, n_gram_len)

	sketches = Sketches.calculate_for([document_shingles], sketch_size)
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

	# p similar_docs.sort_by {|_key, value| value}
	near_duplicates = []
	max_similarity = similar_docs.values.max
	similar_docs.each {|k,v| near_duplicates << k if v >= max_similarity*similarity_percentage}
	p "max_similarity = #{max_similarity} from #{sketch_size}"

	coll = db["Documents"]
	near_duplicates.each do |id|
		doc = coll.find_one("_id" => id)
		next if doc.nil?
		p doc
	end

	# calc_dist(searched_id, near_duplicates)
end

if __FILE__ == $0
	raise "usage: find_similar.rb SEARCHED_TEXT SIMILARITY_PERCENTAGE=[0..1]" unless ARGV.length == 2
	searched_text = ARGV[0].dup
	similarity_percentage = ARGV[1].to_f
	find_similar(searched_text, similarity_percentage)
end