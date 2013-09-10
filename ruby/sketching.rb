# require File.dirname(__FILE__)+'/universal_hash'
#require 'random_permutation'
require 'murmurhash3'
# require 'digest/sha1'
require 'zlib'
require 'cityhash'
# require 'ap'

class Sketch
	attr_reader :sketch

	def initialize elems
		@elems = elems
		@sketch = []
	end

	def apply_hash 
		hashed_shingles = get_all_hashed_shingles
		# SKETCH_SIZE.times { @sketch << hashed_shingles[rand(hashed_shingles.size)] }
		# @sketch = hashed_shingles.sort[-SKETCH_SIZE..-1]
		@sketch = hashed_shingles.sort[0...SKETCH_SIZE]

		# sketch_shingles = {}
		# @elems.each { |elem| sketch_shingles[CityHash.hash64(elem)] = elem}
		# p "Selected hashes : "
		# ap @sketch.each.collect {|e| sketch_shingles[e]}

		# @sketch << @elems.each.collect { |elem| MurmurHash3::V32.str_hash elem}.sort[0...SKETCH_SIZE]
		# @sketch.flatten!

		@sketch = hashed_shingles if hashed_shingles.size <= SKETCH_SIZE
		@sketch
	end

	def get_all_hashed_shingles
		# @sketch = @elems.each.collect { |elem| CityHash.hash64 elem }
		@sketch = @elems.each.collect { |elem| MurmurHash3::V32.str_hash elem}
		@sketch
		# hashed_shingles = @elems.each.collect { |elem| Digest::SHA1.hexdigest(elem).to_i(16)}
		# hashed_shingles = @elems.each.collect { |elem|Zlib::crc32 elem}
		# hashed_shingles = @elems.each.collect { |elem| MurmurHash3::V128.str_hash(elem).join.to_i }
	end
	# def apply_hash hash_fn
	# 	@sketch << @elems.each.collect { |elem| hash_fn.hash elem }.min
	# end
end

class Sketches
	
	def self.calculate_for elems
		sketches = elems.reject{ |e| e.empty? }.collect { |e| Sketch.new(e)  }
		sketches.each { |s| s.apply_hash }

		# SKETCH_SIZE.times do 
		# 	hash_fn = UniversalHash.build
		# 	sketches.each { |s| s.apply_hash hash_fn }
		# end
		
		sketches
	end

	def self.calculate_for_all elems
		sketches = elems.reject{ |e| e.empty? }.collect { |e| Sketch.new(e)  }
		sketches.each { |s| s.get_all_hashed_shingles }
	end

end
	
