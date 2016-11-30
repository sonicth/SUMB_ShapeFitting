--common_su_shapefitting.lua
		targetextension (".so")
		implibextension (".lib")
		kind "SharedLib"
		--pchsource	("sketchup/includes-shapefitting.cpp")
		--pchheader	("includes-shapefitting.h")
		
		files {	"sketchup/*",
					-- also add ruby scripts - not compiled are there to change
					"Scripts/**.rb",
					--20nov2016: also include shared stuff
					"sketchup/RubyUtils/*",
			}
		links {	"ShapeFittingDyLib",
			}
	
		postbuildcommands {
			"../../update-ShapeFitting.cmd"
			}
