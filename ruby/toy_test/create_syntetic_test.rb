#!/usr/bin/env ruby
# encoding: utf-8

SAMPLE = "Shockwave FlashShockwave Flash 11.5 r31application/x-shockwave-flash,swf,application/futuresplash,spl Chrome Remote Desktop ViewerThis plugin allows you to securely access other computers that have been shared with you. To use this plugin you must first install the <a href=https://chrome.google.com/remotedesktop>Chrome Remote Desktop</a> webapp.application/vnd.chromium.remoting-viewer, Native Clientapplication/x-nacl,nexe Chrome PDF Viewerapplication/pdf,pdf,application/x-google-chrome-print-preview-pdf,pdf Kaspersky Anti-VirusUrl Advisor Pluginapplication/kav_urladvisorplugin,rts Kaspersky Anti-VirusChrome Virtual Keyboardapplication/x-kav-vkbd,rts Kaspersky Anti-VirusAntiBanner Pluginapplication/kav_abplugin,rts Google Earth PluginGEPluginapplication/geplugin, Google UpdaterGoogle Updater plugin<br><a href=http://pack.google.com/>http://pack.google.com/</a>application/x-vnd.google.cominstctrl.14,rts PicasaPicasa pluginapplication/x-picasa-detect,pinstall Google UpdateGoogle Updateapplication/x-vnd.google.update3webcontrol.3,,application/x-vnd.google.oneclickctrl.9, Silverlight Plug-In4.1.10329.0application/x-silverlight,scr,application/x-silverlight-2, Windows Live Photo GalleryNPWLPGapplication/x-wlpg3-detect,wlpg,application/x-wlpg-detect,wlpg Shockwave FlashShockwave Flash 11.4 r402application/x-shockwave-flash,swf,application/futuresplash,spl Java Deployment Toolkit 7.0.70.11NPRuntime Script Plug-in Library for Java(TM) Deployapplication/java-deployment-toolkit,"

cntr = 0
N = SAMPLE.size
REPLACE_SYMBOL = "!"
FILE_NAME = "./syntetic_text_only.txt"

File.open(FILE_NAME, 'w') do |file|
	# file.puts "#{cntr}|#{SAMPLE}"
	file.puts "#{SAMPLE}"
	cntr += 1

	#cut off
	N.times do |i|  
		# file.puts"#{cntr}|#{SAMPLE[i..-1]}"
		file.puts"#{SAMPLE[i..-1]}"
		cntr += 1
	end

	#Replace
	N.times do |i|  
		# file.puts"#{cntr}|#{REPLACE_SYMBOL*i + SAMPLE[i..-1]}"
		file.puts"#{REPLACE_SYMBOL*i + SAMPLE[i..-1]}"
		cntr += 1
	end

end
