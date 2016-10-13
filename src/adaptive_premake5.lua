local BOOSTINC_DIR
local BOOSTLIB_DIR
local GLM_DIR
local GTE_DIR
local BUILD_DIR			= ("../build")

--TODO relative paths for externals frameworks - should go into ./ThirdParty
--
--		VS2013 istallation
-- BOOSTINC_DIR				= "k:/Frameworks/boost_1_62_0"
-- BOOSTLIB_DIR				= BOOSTINC_DIR .. "/lib64-msvc-12.0"
-- GLM_DIR						= "K:/frameworks/glm-0.9.7.4"


--		VS2015 istallation
BOOSTINC_DIR = "K:/frameworks/src/boost_1_61_0"
BOOSTLIB_DIR = BOOSTINC_DIR .. "/stage-".._ACTION.."/lib"
--BOOSTLIB_VC10_DIR	= BOOSTINC_DIR .. "/stage-vs2010/lib"
GLM_DIR = "K:/frameworks/src/glm-checkout-git"
GTE_DIR						= "K:/frameworks/src/GeometricTools_3_2/GTEngine/Include"
GTELIB_DIR					= GTE_DIR .. "/../_Output/v140/x64/Release"
GTELIBd_DIR				= GTE_DIR .. "/../_Output/v140/x64/Debug"




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
	
	includedirs {	BOOSTINC_DIR,
					GLM_DIR,
	}
	
	libdirs {	BOOSTLIB_DIR,
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
----------------------------------------------------------------
-- Unit Test tool
----------------------------------------------------------------
	project "AdaptiveAlgorithmsTest"
		kind "ConsoleApp"
		pchsource	("algorithms/includes-test.cpp")
		pchheader	("includes-test.h")
		
		files {	"algorithms/adaptive_test.cpp",
				"algorithms/includes-test.*",
		}
		
		links { "AdaptiveAlgorithmsLib" }
				