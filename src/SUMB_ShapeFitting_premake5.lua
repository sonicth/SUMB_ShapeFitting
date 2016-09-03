local BOOSTINC_DIR
local BOOSTLIB_DIR

local RUBYSDKINC_64_DIR
local RUBYSDKPLAT_64_DIR
local RUBYSDKLIB_DIR

local GLM_DIR

local BUILD_DIR			= ("../build/")
local RUBYUTILS_DIR	=  "../ThirdParty/RubyUtils"

BOOSTINC_DIR				= "k:/frameworks/src/boost_1_61_0"
BOOSTLIB_DIR				= BOOSTINC_DIR .. "/stage-".._ACTION.."/lib"
BOOSTLIB_VC10_DIR	= BOOSTINC_DIR .. "/stage-vs2010/lib"
RUBYSDKINC_64_DIR	= "k:/frameworks/src/ruby-c-extension-examples/ThirdParty/include/ruby/2.0/win32_x64"
RUBYSDKPLAT_64_DIR	= RUBYSDKINC_64_DIR .. "/x64-mswin64_100"
RUBYSDKLIB_DIR			= RUBYSDKINC_64_DIR .. "/../../../../lib/win32"
GLM_DIR						= "K:/frameworks/src/glm-checkout-git"


solution "SketchupShapeFitting"
	language "C++"
	location (BUILD_DIR .. _ACTION)
	targetdir (BUILD_DIR .. "products")
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

----------------------------------------------------------------
-- The actual plugin .so
----------------------------------------------------------------
	project "SUMB_ShapeFitting"
		toolset "v100"
		targetextension (".so")
		implibextension (".lib")
		kind "SharedLib"
		pchsource	("sketchup/includes-shapefitting.cpp")
		pchheader	("includes-shapefitting.h")
		
		files {	"sketchup/*",
		}
			
		links {	"x64-msvcrt-ruby200", 
					"RubyUtilsLib",
		}
		
		libdirs { BOOSTLIB_VC10_DIR }
				
		includedirs {	RUBYSDKINC_64_DIR, 
							RUBYSDKPLAT_64_DIR, 
							RUBYUTILS_DIR .. "/..",
							GLM_DIR,
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
