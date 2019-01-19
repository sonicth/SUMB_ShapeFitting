local BUILD_DIR			= ("../build")

dofile "externals.lua"

solution "SketchupShapeFitting"
	language "C++"
	location (BUILD_DIR .. "/" .. _ACTION)
	targetdir (BUILD_DIR .. "/products")
	configurations { "Debug", "Release" }
	platforms { "x64" }
	
	defines {	"_USE_MATH_DEFINES", 
					"SUMB_PLUGIN_SHAPE_FITTING",
	}
	
	if os.get() == "windows" then
		buildoptions { 
				"-Zm700",		--compiler may choke on pch unless more memory is given explicitly 
		}
	end
	
	includedirs {	BOOST_INC_DIR,
	}
	includedirs {	RUBYUTILS_DIR .. "/..",
					GLM_INC_DIR,
					BOOST_INC_DIR,
	}			
	
	libdirs {	BOOST_LIB_DIR,
				RUBYSDK_LIB_DIR,
	}
	
	linkoptions { 
	}
	
	debugdir "$(TargetDir)"

	configuration "Debug"
		defines { "DEBUG" }
		flags { "Symbols" }

	configuration "Release"
		defines { "NDEBUG" }
		flags { "Optimize" }
		targetdir (BUILD_DIR .. "/products/release")

----------------------------------------------------------------
-- The actual plugin .so
----------------------------------------------------------------
--TODO debug command:
--		"C:\Program Files\SketchUp\SketchUp 2016\SketchUp.exe"			
	project "SUMB_ShapeFitting_rb22"
		dofile "common_su_shapefitting.lua"
		-- toolset "v140"
		defines { "RUBY22" }
		files {	RUBYUTILS_DIR .. "/**",	}
		excludes { "sketchup/SUMB_ShapeFitting_rb20.def" }
		links {	"x64-msvcrt-ruby220", 
			}
		libdirs { BOOST_LIB_DIR }			
		includedirs {	RUBYSDK_INC_DIR .. "/2.2/win32_x64", 
							RUBYSDK_INC_DIR .. "/2.2/win32_x64/x64-mswin64_140"
			}

			
--TODO move to solution def

--==================================
--vs2015
--==================================

----------------------------------------------------------------
-- GTE Adaptor library with includes
----------------------------------------------------------------
dofile "proj_lib_gte_adapter_premake5.lua"

----------------------------------------------------------------
-- DLL library
----------------------------------------------------------------
	project "ShapeFittingDyLib"
		kind "SharedLib"
		
		flags { "StaticRuntime" }
		
		files {	"shared/fit-poly.*",
					"shared/shared-geometry.*",
		}
		
		links {	"GteLib", "AlgorithmsLib",		-- local dependencies in project
					"ImportExportLib",					-- write/read obj for debugging
		}
		
		includedirs {	GLM_INC_DIR,
		}
		
		libdirs {	BOOST_LIB_DIR, GTE_LIB_DIR
		}	
		
		configuration "Debug"
			links { "GTEngine.v14-gl4debug" }

		configuration "Release"
			links { "GTEngine.v14-gl4release" }

----------------------------------------------------------------
-- algorithms project (own work)
----------------------------------------------------------------
	project "AlgorithmsLib"
		kind "StaticLib"		
		flags { "StaticRuntime" }
		pchsource	("algorithms/includes-algorithms.cpp")
		pchheader	("includes-algorithms.h")
		
		files {	"algorithms/*",
					"boost/*",
		}
		
		excludes { "algorithms/adaptive_test.cpp" }
						
		includedirs {	GLM_INC_DIR,
		}
----------------------------------------------------------------
-- Import/Export
----------------------------------------------------------------
dofile "proj_lib_impexp_premake5.lua"
