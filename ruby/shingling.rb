require 'set'

# N_GRAM_LEN = 3
# MODE_WORDS = true

class String

	def shingles
		return @cached if @cached	
		squeezed = self.squeeze(" ")
		n_grams = Set.new
		if SHINGLE_MODE == "-w"
			(squeezed.count(" ") - N_GRAM_LEN + 2).times do |i| 
				n_grams << squeezed.split[i...i+N_GRAM_LEN].join(' ')
			end
		elsif SHINGLE_MODE == "-c"
			(length-N_GRAM_LEN+1).times do |i| 
				n_grams << slice(i, N_GRAM_LEN) 
			end
		else
			raise "Wrong SHINGLE_MODE : #{SHINGLE_MODE}"
		end	
	    @cached = n_grams
		n_grams
	end

	def jaccard_similarity_coeff(b)
		sa = shingles
		sb = b.shingles
		numerator = (sa.intersection sb).size
		denominator = (sa.union sb).size	
		numerator.to_f / denominator  
	end

	def jaccard_distance(b)        
		xor = 0
		union = 0
		shingles.union(b.shingles).each do |shingle|
		  in_a = shingles.include? shingle
		  in_b = b.shingles.include? shingle
		  xor +=1 if in_a ^ in_b
		  union +=1 if in_a & in_b
		end
		xor.to_f / (xor+union)
	end

	def invalidate_cache
		@cached = nil
	end

end


