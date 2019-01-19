----------------------------------------------------------------
-- GTE project
----------------------------------------------------------------

	project "GteLib"
		kind "StaticLib"		
		flags { "StaticRuntime" }
		pchsource	("gte/includes-gte.cpp")
		pchheader	("includes-gte.h")
		
		files {	"../../SUMB_ShapeFitting/src/gte/*",
		}
						
		includedirs {	GTE_INC_DIR,
						GLM_DIR,
		}