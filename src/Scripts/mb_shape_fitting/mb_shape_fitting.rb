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

		def self.runShapeFitting(ftting_params)		
			
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
					
					#fit!!!
					result_poly_pts = suFitShape(input_region_geometry, ftting_params)

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
		
		LEFTCOL = 90
		
		def self.initUI
			options = {
			  :title           => 'Shape Fitting',
			  :preferences_key => 'shape_fitting',
			}
			w = SKUI::Window.new( options )
			
			
			# type of box
			box_names = [ "Axis Aligned", "Oriented" ]
			drop_boxtype = SKUI::Listbox.new( box_names )
			#puts "debug item #{drop_boxtype.items.first}"
			drop_boxtype.value = drop_boxtype.items.first
			drop_boxtype.name = :box_type
			drop_boxtype.position( LEFTCOL, 38 )
			drop_boxtype.width = 170
			drop_boxtype.on( :change ) { |control, value| # (?) Second argument needed?
				boxtype = control.value
				puts "Box type #{boxtype}"
			}
			w.add_control( drop_boxtype )
			
			# 	label for box type 
			lbl_boxtype = SKUI::Label.new( 'Box type:', drop_boxtype )
			lbl_boxtype.position( 12, 40 )
			lbl_boxtype.width = 50
			w.add_control( lbl_boxtype )
			
			
			# list of methods
			#list = %w{ items are separated by space }
			method_hash = { "Box" => 0, "Adaptive" => 1, "Axis Corners" => 2, "First Four" => 3 }
			method_names = method_hash.keys
			drop_method = SKUI::Listbox.new( method_names )
			drop_method.value = drop_method.items.first
			drop_method.name = :method_name
			drop_method.position( LEFTCOL, 12 )
			drop_method.width = 170
			drop_method.on( :change ) { |control, value| # (?) Second argument needed?
				selected_name = control.value
				selected_method = method_hash[selected_name]
				show_box_type = true
				if selected_method == 1
					show_box_type = false
				end
				drop_boxtype.enabled = show_box_type
				lbl_boxtype.enabled = show_box_type
				
				
				#puts "Method id: #{selected_method_id} ('#{selected_name}'), show box: #{show_box_type}"
			}
			w.add_control( drop_method )
			
			#	.. label for list
			lbl_method = SKUI::Label.new( 'Method:', drop_method )
			lbl_method.position( 12, 12+2 )
			lbl_method.width = 50
			w.add_control( lbl_method )

			b = SKUI::Button.new( 'Fit Shapes' ) { |control|
				method = control.window[:method_name].value
				box_type = control.window[:box_type].value
				# method id
				method = method_hash[method];
				# box type
				box_type_id = 0
				if box_type == "Oriented"
					box_type_id = 1
				end
	
				#pass to shape fitter
				dlg = runShapeFitting({"method"=>method, "box_type"=>box_type_id })
			}
			b.position( LEFTCOL, 70 )
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