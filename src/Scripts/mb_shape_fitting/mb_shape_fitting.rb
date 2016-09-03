# Copyright 2016 Mike Vasiljevs
# quick load
#			load "mv_park_generator/mv_generate.rb"

module MikeBasille

	module ShapeFitting
		plugin_platform = 'win_x64'
		plugin_name = File.dirname(__FILE__) + "/" + plugin_platform + '/' + 'SUMB_ShapeFitting.so'


		require plugin_name

		#@_object = 0xfeedbaaddeadbeef;
		DEBUUG = true;
		

		def self.runShapeFitting
			puts "calling shape fitting..."
			suFitShape([[10,20]]);
			puts "done!"
		end

	end #shapefitting
	

	unless file_loaded?(__FILE__)
		UI.menu("Plugins").add_item("Shape Fitting") {
			dlg = ShapeFitting.runShapeFitting
		}
		file_loaded(__FILE__)
		
	end # unless
	
end # mikebasille