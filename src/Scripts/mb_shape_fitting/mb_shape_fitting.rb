=begin
Copyright 2016 Mike Vasiljevs
All Rights Reserved
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
Author: Mike Vasiljevs 
Organization: Mike Basille
Name: ShapeFitting
=end

# quick load
#			load "mv_park_generator/mv_generate.rb"

module MikeBasille

	module ShapeFitting
		plugin_platform = 'win_x64'
		plugin_dir = File.dirname(__FILE__)
		plugin_name = plugin_dir + "/" + plugin_platform + '/' + 'SUMB_ShapeFitting.so'
		#UI library
		skui_path = File.join( plugin_dir, 'SKUI' )
		load File.join( skui_path, 'embed_skui.rb' )
		::SKUI.embed_in( self )

		require plugin_name

		#@_object = 0xfeedbaaddeadbeef;
		DEBUUG = true;
		
		def self.getSelectedFacesPoints
			model = Sketchup.active_model

			sel = model.selection;

			# faces
			faces = []
			# other components - should be empty or ignored
			others = []

			sel.each do |e|
				if e.is_a? Sketchup::Face
					faces.push(e)
				else
					others.push(e)
				end #if
			end #do

			if faces.empty?
				UI.messagebox("No faces are selected. Please select a face where to generate a park into and try again.")
				# model.abort_operation
				return []
			end

			#if faces.length > 1
			#	UI.messagebox("There are #{faces.length} faces selected. Can only deal with a single face at the moment. Will use the first face.");
			#	return []
			#end

			if not others.empty?
				puts "warning! expected faces only in the selection, selected #{others.length} other objects! Continuing..."
			end
			
			face_data = []

			faces.each { |f|
				vxs = f.vertices

				pts = []
				#TODO test for planarity
				vxs.each do |vx|
					pt = vx.position
					pts.push([pt.x.to_f, pt.y.to_f])
				end
				
				face_data.push({:face_object => f, :points => pts})
			}

			#puts "face with #{pts.length} points found."
			return face_data;

		end #getSelectedFacesPoints
		
		def self.addPoly(pts, y_offset = 0)
		
			model = Sketchup.active_model
			ent = model.entities

			# unique points!
			upts = pts.uniq
			
			# convert arrays to vectors
			vpts = []
			upts.each { |pt| 
				vx = Geom::Point3d.new [pt[0], pt[1], y_offset]
				vpts.push(vx) 
			}

			new_face = ent.add_face vpts
			
		end #adding poly

		def self.runShapeFitting		
			
			face_data = getSelectedFacesPoints
					
			model = Sketchup.active_model
			
			if face_data.empty?
				return
			end


			# for multiple faces make Undo message nicer
			if face_data.length == 1
				model.start_operation("Shape Fitting", true)
			else
				model.start_operation("Shape Fitting (#{face_data.length} faces)", true)
			end
					
			_face_idx = 0;
			face_data.each  { |fh|
				
				if DEBUUG
					puts "\ninput region [#{_face_idx}]"
				end
				
				input_region_geometry = fh[:points]
				
				if not input_region_geometry.empty?
					puts "creating fitting polygon..."
					
					#TODO add UI for this
					fit_method = 3
					result_poly_pts = suFitShape(input_region_geometry, fit_method)

					if not result_poly_pts.empty?
						
						
						puts "adding fitted polygon..."
						
						# delete face
						#deleteFaces([ fh[:face_object] ])
													
						addPoly(result_poly_pts, 0.01)
						puts "done."
						
					end #not empty result
				end #not empty input
				
				_face_idx += 1
			}
			
			model.commit_operation
			
		end #run shape fitting
		
		def self.initUI
			options = {
			  :title           => 'Shape Fitting',
			  :preferences_key => 'shape_fitting',
			}
			w = SKUI::Window.new( options )
			
			# list of methods
			list = %w{ Adapted Box }
			lst_dropdown = SKUI::Listbox.new( list )
			lst_dropdown.value = lst_dropdown.items.first
			lst_dropdown.name = :method_name
			lst_dropdown.position( 100, 12 )
			lst_dropdown.width = 170
			lst_dropdown.on( :change ) { |control, value| # (?) Second argument needed?
			  puts "Dropbox value: #{control.value}"
			}
			w.add_control( lst_dropdown )
			#	.. label for list
			lbl_input = SKUI::Label.new( 'Method:', lst_dropdown )
			lbl_input.position( 10, 12 )
			lbl_input.width = 50
			w.add_control( lbl_input )
			
			b = SKUI::Button.new( 'Fit Shapes' ) { |control|
				method = control.window[:method_name].value
				puts "using method #{method}!"
				dlg = runShapeFitting()
			}
			b.position( 10, 50 )
			w.add_control( b )
			
			# shwo window!
			w.show
		end #initui

	end #shapefitting
	

	unless file_loaded?(__FILE__)
		UI.menu("Plugins").add_item("Shape Fitting") {
			ShapeFitting.initUI()
		}
		file_loaded(__FILE__)
		
	end # unless
	
end # mikebasille