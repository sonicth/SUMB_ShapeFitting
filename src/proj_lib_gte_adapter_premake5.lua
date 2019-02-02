----------------------------------------------------------------
-- GTE project
----------------------------------------------------------------
-- NOTE externals (framework paths) needed since this one can be included from other projects
dofile "externals.lua"

print ("gte project")
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
						GLM_INC_DIR,
		}
