=begin
Copyright 2016 Mike Vasiljevs
All Rights Reserved
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
Author: Mike Vasiljevs 
Organization: Mike Basille
Name: ShapeFitting
=end

module MikeBasille
	module ShapeFitting
		require 'sketchup.rb'
		require 'extensions.rb'

		mv_plugin_loader = SketchupExtension.new "Shape Fitting", "mb_shape_fitting/mb_shape_fitting.rb"
		mv_plugin_loader.copyright	= "Copyright 2016 by Mike Vasiljevs"
		mv_plugin_loader.creator	= "Mike Basille"
		mv_plugin_loader.version	= "0.2.1"
		mv_plugin_loader.description	= "Fit a Quad to a selected Polygon Face."
		Sketchup.register_extension mv_plugin_loader, true
		
	end #parkgenerator
end #mikebasille

