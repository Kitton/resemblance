# require File.dirname(__FILE__)+'/universal_hash'
#require 'random_permutation'
require 'murmurhash3'

class Sketch
	attr_reader :sketch

	def initialize elems
		@elems = elems
		@sketch = []
	end

	def apply_hash 
		@sketch << @elems.each.collect { |elem| MurmurHash3::V32.str_hash elem}.sort[0...SKETCH_SIZE]
		@sketch.flatten!
	end
	# def apply_hash hash_fn
	# 	@sketch << @elems.each.collect { |elem| hash_fn.hash elem }.min
	# end

end

class Sketches
	
	def self.calculate_for elems
		sketches = elems.collect { |e| Sketch.new(e) }
		sketches.each { |s| s.apply_hash }

		# SKETCH_SIZE.times do 
		# 	hash_fn = UniversalHash.build
		# 	sketches.each { |s| s.apply_hash hash_fn }
		# end
		
		sketches
	end

end
	
