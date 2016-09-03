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
		
		def self.getSelectedFacesPoints
			model = Sketchup.active_model

			sel = model.selection;

			# faces
			faces = []
			# other components - should be empty or ignored
			others = []

			sel.each do |e|
				case e.typename
#				when "ComponentInstance"
#					components.push(e)
				when "Face"
					faces.push(e)
				else
					others.push(e)
				end
			end

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

		end
		
		def self.addPoly(pts)
		
			model = Sketchup.active_model
			ent = model.entities

			# unique points!
			upts = pts.uniq
			
			# convert arrays to vectors
			vpts = []
			upts.each { |pt| 
				vx = Geom::Point3d.new [pt[0], pt[1], 0]
				vpts.push(vx) 
			}

			new_face = ent.add_face vpts
			
		end #adding poly

		def self.runShapeFitting		
			
			face_data = getSelectedFacesPoints
					
			model = Sketchup.active_model
					
			_face_idx = 0;
			face_data.each  { |fh|
				
				if DEBUUG
					puts "\ninput region [#{_face_idx}]"
				end
				
				input_region_geometry = fh[:points]
				
				if not input_region_geometry.empty?
					puts "creating fitting polygon..."
					
					result_poly_pts = suFitShape(input_region_geometry)

					if not result_poly_pts.empty?
						model.start_operation("fitting polygon with #{result_poly_pts.length} points...", true)
						
						puts "adding fitted polygon..."
						
						# delete face
						#deleteFaces([ fh[:face_object] ])
													
						addPoly(result_poly_pts)
						puts "done."
						
						model.commit_operation
					end #not empty result
				end #not empty input
				
				_face_idx += 1
			}
			
		end #run shape fitting

	end #shapefitting
	

	unless file_loaded?(__FILE__)
		UI.menu("Plugins").add_item("Shape Fitting") {
			dlg = ShapeFitting.runShapeFitting
		}
		file_loaded(__FILE__)
		
	end # unless
	
end # mikebasille