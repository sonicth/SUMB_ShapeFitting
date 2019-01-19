local BUILD_DIR			= ("../build")

dofile "externals.lua"

solution "FittingAlgorithms"
	language "C++"
	location (BUILD_DIR .. "/" .. _ACTION)
	targetdir (BUILD_DIR .. "/products")
	configurations { "Debug", "Release" }
	platforms { "x64" }
	flags { "StaticRuntime" }
	
	defines {	"_USE_MATH_DEFINES", 
					"SUMB_PLUGIN_SHAPE_FITTING",
	}
	
	if os.get() == "windows" then
		buildoptions { 
				"-Zm700",		--compiler may choke on pch unless more memory is given explicitly 
		}
	end
	
	includedirs {	BOOST_INC_DIR,
					GTE_INC_DIR,
					GLM_INC_DIR,
	}
	
	libdirs {	BOOST_LIB_DIR,
	}
	
	linkoptions { 
	}
	
	debugdir "$(TargetDir)"

	configuration "Debug"
		defines { "DEBUG" }
		-- symbols "On"
		flags { "Symbols" }

	configuration "Release"
		defines { "NDEBUG" }
		flags { "Optimize" }
		targetdir (BUILD_DIR .. "/products/release")

----------------------------------------------------------------
-- Algorithms Library
dofile "proj_lib_adaptive_premake5.lua"
-- Import/Export
dofile "proj_lib_impexp_premake5.lua"
----------------------------------------------------------------
-- Unit Test tool
----------------------------------------------------------------
	project "AdaptiveAlgorithmsTest"
		kind "ConsoleApp"
		
		files {	"algorithms/adaptive_test.cpp",
		}
		
		links { "AdaptiveAlgorithmsLib", "ImportExportLib" }
				