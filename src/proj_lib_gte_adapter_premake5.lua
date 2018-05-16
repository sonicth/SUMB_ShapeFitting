----------------------------------------------------------------
-- GTE project
----------------------------------------------------------------
GTE_DIR						= "K:/frameworks/src/GeometricTools_3_2/GTEngine/Include"
GTELIB_DIR					= GTE_DIR .. "/../_Output/v140/x64/Release"
GTELIBd_DIR				= GTE_DIR .. "/../_Output/v140/x64/Debug"


	project "GteLib"
		kind "StaticLib"		
		flags { "StaticRuntime" }
		pchsource	("gte/includes-gte.cpp")
		pchheader	("includes-gte.h")
		
		files {	"gte/*",
		}
						
		includedirs {	GTE_DIR,
							GLM_DIR,
		}