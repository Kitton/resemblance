#!/usr/bin/env ruby
# encoding: utf-8

FILENAME = "./top_cookies_plus.txt"

require 'mongo'
include Mongo

if __FILE__ == $0
	mongo_client = MongoClient.new
	db = mongo_client.db("device_tracking_from_prod")
	coll = db.collection("session")
	cookies = coll.aggregate([
		{ "$group" => {_id: "$user_cookie",n: {"$sum" => 1}}},
		{ "$sort" => {n: -1}},
		{ "$limit" => 10}
		])
	cntr = 0
	File.open(FILENAME, 'w') do |file|
		cookies.each do |e|
			cursor = coll.find("user_cookie" => e["_id"])
			cursor.each do |row|
				next if row["browser"].nil?
				plugin_string = row["browser"]["plugins"].collect {|plugin| plugin.values.join}
				plugin_string = plugin_string.join(" ").gsub(/"/, "")
				file.puts "#{cntr} | #{row["user_cookie"]} | #{plugin_string}"
				cntr += 1
			end
		end
	end

end