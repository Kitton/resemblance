#!/usr/bin/env ruby
# encoding: utf-8

SAMPLE = "Shockwave FlashShockwave Flash 11.5 r31application/x-shockwave-flash,swf,application/futuresplash,splChrome Remote Desktop ViewerThis plugin allows you to securely access other computers that have been shared with you. To use this plugin you must first install the <a href=https://chrome.google.com/remotedesktop>Chrome Remote Desktop</a> webapp.application/vnd.chromium.remoting-viewer,Native Clientapplication/x-nacl,nexeChrome PDF Viewerapplication/pdf,pdf,application/x-google-chrome-print-preview-pdf,pdfKaspersky Anti-VirusUrl Advisor Pluginapplication/kav_urladvisorplugin,rtsKaspersky Anti-VirusChrome Virtual Keyboardapplication/x-kav-vkbd,rtsKaspersky Anti-VirusAntiBanner Pluginapplication/kav_abplugin,rtsGoogle Earth PluginGEPluginapplication/geplugin,Google UpdaterGoogle Updater plugin<br><a href=http://pack.google.com/>http://pack.google.com/</a>application/x-vnd.google.cominstctrl.14,rtsPicasaPicasa pluginapplication/x-picasa-detect,pinstallGoogle UpdateGoogle Updateapplication/x-vnd.google.update3webcontrol.3,,application/x-vnd.google.oneclickctrl.9,Silverlight Plug-In4.1.10329.0application/x-silverlight,scr,application/x-silverlight-2,Windows Live Photo GalleryNPWLPGapplication/x-wlpg3-detect,wlpg,application/x-wlpg-detect,wlpgShockwave FlashShockwave Flash 11.4 r402application/x-shockwave-flash,swf,application/futuresplash,splJava Deployment Toolkit 7.0.70.11NPRuntime Script Plug-in Library for Java(TM) Deployapplication/java-deployment-toolkit,"

cntr = 0
N = SAMPLE.size
REPLACE_SYMBOL = "!"

File.open("./syntetic.txt", 'w') do |file|
	file.puts "#{cntr}|#{SAMPLE}"
	cntr += 1

	#cut off
	N.times do |i|  
		file.puts"#{cntr}|#{SAMPLE[i..-1]}"
		cntr += 1
	end

	#Replace
	N.times do |i|  
		file.puts"#{cntr}|#{REPLACE_SYMBOL*i + SAMPLE[i..-1]}"
		cntr += 1
	end

end
