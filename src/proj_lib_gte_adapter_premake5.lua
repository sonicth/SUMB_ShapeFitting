----------------------------------------------------------------
-- GTE project
----------------------------------------------------------------
GTE_DIR						= FRAMEWORK_PATH .."/GeometricTools_3_2/GTEngine/Include"
GTELIB_DIR					= GTE_DIR .. "/../_Output/v140/x64/Release"
GTELIBd_DIR				= GTE_DIR .. "/../_Output/v140/x64/Debug"


	project "GteLib"
		kind "StaticLib"		
		flags { "StaticRuntime" }
		pchsource	("gte/includes-gte.cpp")
		pchheader	("includes-gte.h")
		
		files {	
			"gte/*",
			"shared/shared-geometry.*",
		}
						
		includedirs {	GTE_DIR,
							GLM_DIR,
		}