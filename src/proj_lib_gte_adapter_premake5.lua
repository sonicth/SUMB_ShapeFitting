----------------------------------------------------------------
-- GTE project
----------------------------------------------------------------

	project "GteLib"
		kind "StaticLib"		
		flags { "StaticRuntime" }
		pchsource	("gte/includes-gte.cpp")
		pchheader	("includes-gte.h")
		
		files {	
			"gte/*",
			"shared/shared-geometry.*",
		}
						
		includedirs {	GTE_INC_DIR,
						GLM_DIR,
		}