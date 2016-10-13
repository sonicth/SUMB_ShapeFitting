----------------------------------------------------------------
-- Import/Export library
----------------------------------------------------------------
	project "ImportExportLib"
		kind "StaticLib"
		-- pchsource	("io/includes-io.cpp")
		-- pchheader	("includes-io.h")
		includedirs { "../ThirdParty/TinyObjLoader/" }
		
		files {	"io/*.*",
					"../ThirdParty/TinyObjLoader/tiny_obj_loader.h",
					"../ThirdParty/TinyObjLoader/tiny_obj_loader.cc",
		}
		
		excludes { "io/includes-io.*" }