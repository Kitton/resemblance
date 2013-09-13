# encoding: utf-8
require 'set'

class String

	def get_rid_of_accents
		return self.tr(
			"ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
			"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
		)
	end

	def shingles(shingle_mode, n_gram_len)
		squeezed = self.squeeze(" ")
		squeezed = squeezed.get_rid_of_accents
		n_grams = Set.new
		if shingle_mode == "-w"
			(squeezed.count(" ") - n_gram_len + 2).times do |i| 
				n_grams << squeezed.split[i...i+n_gram_len].join(' ')
			end
		elsif shingle_mode == "-c"
			(squeezed.length - n_gram_len + 1).times do |i| 
				n_grams << squeezed.slice(i, n_gram_len) 
			end
		else
			raise "Wrong shingle_mode : #{shingle_mode}"
		end	
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
end


