local BOOSTINC_DIR
local BOOSTLIB_DIR

local RUBYSDKINC_64_DIR
local RUBYSDKPLAT_64_DIR
local RUBYSDKLIB_DIR

local GLM_DIR

local GMP_DIR

local GTE_DIR

local BUILD_DIR			= ("../build")
local RUBYUTILS_DIR	=  "../ThirdParty/RubyUtils"

local MAYA_SDK_DIR
local MAYA_LIB_DIR


--TODO relative paths for externals frameworks - should go into ./ThirdParty
BOOSTINC_DIR				= "k:/frameworks/src/boost_1_61_0"
BOOSTLIB_DIR				= BOOSTINC_DIR .. "/stage-".._ACTION.."/lib"
BOOSTLIB_VC10_DIR	= BOOSTINC_DIR .. "/stage-vs2010/lib"
RUBYSDKINC_64_DIR	= "k:/frameworks/src/ruby-c-extension-examples/ThirdParty/include/ruby/2.0/win32_x64"
RUBYSDKPLAT_64_DIR	= RUBYSDKINC_64_DIR .. "/x64-mswin64_100"
RUBYSDKLIB_DIR			= RUBYSDKINC_64_DIR .. "/../../../../lib/win32"
GLM_DIR						= "K:/frameworks/src/glm-checkout-git"
GTE_DIR						= "K:/frameworks/src/GeometricTools_3_2/GTEngine/Include"
GTELIB_DIR					= GTE_DIR .. "/../_Output/v140/x64/Release"
GTELIBd_DIR				= GTE_DIR .. "/../_Output/v140/x64/Debug"
-- Maya SDK
MAYA_SDK_DIR = "K:/frameworks/SDKs/Maya2017"
MAYA_LIB_DIR = "C:/Program Files/Autodesk/Maya2017/lib"




solution "ShapeFittingPlugins"
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
	
	includedirs {	BOOSTINC_DIR,
	}
	
	libdirs {	BOOSTLIB_DIR,
				RUBYSDKLIB_DIR,
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
-- SketchUp  .so plugin
----------------------------------------------------------------
--TODO debug command:
--		"C:\Program Files\SketchUp\SketchUp 2016\SketchUp.exe"
	project "SUMB_ShapeFitting"
		toolset "v100"
		targetextension (".so")
		implibextension (".lib")
		kind "SharedLib"
		pchsource	("sketchup/includes-shapefitting.cpp")
		pchheader	("includes-shapefitting.h")
		
		files {	"sketchup/*",
					-- also add ruby scripts - not compiled are there to change
					"Scripts/**.rb",
		}
			
		links {	"x64-msvcrt-ruby200", 
					"RubyUtilsLib",
					"ShapeFittingDyLib",
		}
		
		libdirs { BOOSTLIB_VC10_DIR }
				
		includedirs {	RUBYSDKINC_64_DIR, 
							RUBYSDKPLAT_64_DIR, 
							RUBYUTILS_DIR .. "/..",
							GLM_DIR,
		}
				
		postbuildcommands {
			"../../update-ShapeFitting.cmd"
		}
		--TODO TARGET		C:\Program Files\SketchUp\SketchUp 2016\SketchUp.exe
----------------------------------------------------------------
-- Maya  .mll plugin
----------------------------------------------------------------
	project "ShapeFittingCmd"
		targetextension (".mll")
		implibextension (".lib")
		kind "SharedLib"
		flags { "StaticRuntime" }
		
		pchsource	("maya/includes-maya.cpp")
		pchheader	("includes-maya.h")
		
		files {	"maya/*",
		}
			
		links {	"Foundation", "OpenMaya", "OpenMayaUI", "OpenMayaAnim", 
					"ShapeFittingDyLib",
		}
		
		libdirs { BOOSTLIB_DIR,
					MAYA_LIB_DIR,
			}
				
		includedirs {	GLM_DIR,
							MAYA_SDK_DIR .. "/include",
		}

----------------------------------------------------------------
-- Third party ruby code
----------------------------------------------------------------
	project "RubyUtilsLib"
		toolset "v100"
		kind "StaticLib"		
		files {	RUBYUTILS_DIR .. "/**",
					"sketchup/RubyUtils/*",
		}
						
				--TODO move to solution def
		includedirs {	RUBYSDKINC_64_DIR,
							RUBYSDKPLAT_64_DIR,
							RUBYUTILS_DIR .. "/..",
							GLM_DIR,
		}
--==================================
--vs2015
--==================================
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
					"GTEngine.v14",
					"ImportExportLib",					-- write/read obj for debugging
		}
		
		includedirs {	GLM_DIR,
		}
		
		libdirs {	BOOSTLIB_DIR,
		}		
		
		configuration "Debug"
			libdirs {	GTELIBd_DIR,	
			}
			
		configuration "Release"
			libdirs {	GTELIB_DIR,	
			}
----------------------------------------------------------------
-- GTE project
----------------------------------------------------------------
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
						
		includedirs {	GLM_DIR,
		}
----------------------------------------------------------------
-- Import/Export
----------------------------------------------------------------
dofile "proj_lib_impexp_premake5.lua"
