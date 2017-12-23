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
PATH = ("build/" .. _ACTION)



--TODO relative paths for externals frameworks - should go into ./ThirdParty
if os.get() == "windows" then

	BOOSTINC_DIR = "C:/Users/mikev/Documents/frameworks/boost_1_64_0"
	--BOOSTINC_DIR = "E:/external/boost_1_61_0"
	BOOSTLIB_DIR = BOOSTINC_DIR .. "/stage-".. (_ACTION) .."/lib"
	BOOSTLIB_DIR_VC10 = BOOSTINC_DIR .. "/stage-vs2010/lib"
	--BOOSTLIB_DIR = BOOSTINC_DIR .. "/../lib"
	-- TODO fix release
	GLM_DIR = "C:/Users/mikev/Documents/frameworks/glm-0.9.8"
	RUBY_SDK_64 		 = "C:/Users/mikev/Documents/frameworks/ruby-c-extension-examples/ThirdParty/include/ruby"
	RUBY_SDK_64_PLATFORM = RUBY_SDK_64
	RUBY_SDK_64_LIB		 = RUBY_SDK_64 .. "/../../lib/win32"
	TARGET_DIR = PATH .. "/../products"
	
else
	
	BOOSTINC_DIR = "/usr/local/Cellar/boost/1.56.0/include"
	BOOSTLIB_DIR = ""
	GLM_DIR = ""
end

RUBYSDKINC_64_DIR	= RUBY_SDK_64
RUBYSDKLIB_DIR			= RUBY_SDK_64_LIB

GTE_DIR = "C:/Users/mikev/Documents/frameworks/GeometricTools/GTEngine/Include"
-- GTE_DIR						= "C:/Users/mikev/Documents/frameworks/src/GeometricTools_3_2/GTEngine/Include"
GTELIB_DIR					= GTE_DIR .. "/../_Output/v141/x64/Release"
GTELIBd_DIR				= GTE_DIR .. "/../_Output/v141/x64/Debug"




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
	
	includedirs {	BOOSTINC_DIR,
	}
	includedirs {	RUBYUTILS_DIR .. "/..",
					GLM_DIR,	
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
-- The actual plugin .so
----------------------------------------------------------------
--TODO debug command:
--		"C:\Program Files\SketchUp\SketchUp 2016\SketchUp.exe"
	project "SUMB_ShapeFitting_rb20"
		dofile "common_su_shapefitting.lua"
		toolset "v100"
		defines { "RUBY20", "BOOST_ALL_DYN_LINK", "_DLL", }
		files {	RUBYUTILS_DIR .. "/**",	}
		excludes { "sketchup/SUMB_ShapeFitting_rb22.def" }
		links {	"x64-msvcrt-ruby200", 
			}
		libdirs { BOOSTLIB_DIR_VC10
			 }			
		includedirs {	RUBYSDKINC_64_DIR .. "/2.0/win32_x64", 
							RUBYSDKINC_64_DIR .. "/2.0/win32_x64/x64-mswin64_100"
			}
			
	project "SUMB_ShapeFitting_rb22"
		dofile "common_su_shapefitting.lua"
		-- toolset "v140"
		defines { "RUBY22", "BOOST_ALL_DYN_LINK", "_DLL", }
		files {	RUBYUTILS_DIR .. "/**",	}
		excludes { "sketchup/SUMB_ShapeFitting_rb20.def" }
		links {	"x64-msvcrt-ruby220", 
			}
		libdirs { BOOSTLIB_DIR }			
		includedirs {	RUBYSDKINC_64_DIR .. "/2.2/win32_x64", 
							RUBYSDKINC_64_DIR .. "/2.2/win32_x64/x64-mswin64_140"
			}

			
--TODO move to solution def

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
