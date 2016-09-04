local BOOSTINC_DIR
local BOOSTLIB_DIR

local RUBYSDKINC_64_DIR
local RUBYSDKPLAT_64_DIR
local RUBYSDKLIB_DIR

local GLM_DIR

local CGAL_DIR
local GMP_DIR

local GTE_DIR

local BUILD_DIR			= ("../build/")
local RUBYUTILS_DIR	=  "../ThirdParty/RubyUtils"

BOOSTINC_DIR				= "k:/frameworks/src/boost_1_61_0"
BOOSTLIB_DIR				= BOOSTINC_DIR .. "/stage-".._ACTION.."/lib"
BOOSTLIB_VC10_DIR	= BOOSTINC_DIR .. "/stage-vs2010/lib"
RUBYSDKINC_64_DIR	= "k:/frameworks/src/ruby-c-extension-examples/ThirdParty/include/ruby/2.0/win32_x64"
RUBYSDKPLAT_64_DIR	= RUBYSDKINC_64_DIR .. "/x64-mswin64_100"
RUBYSDKLIB_DIR			= RUBYSDKINC_64_DIR .. "/../../../../lib/win32"
GLM_DIR						= "K:/frameworks/src/glm-checkout-git"
CGAL_DIR						= "K:/frameworks/build/CGAL-4.9_x64-beta1/include"
CGALPLAT_DIR				= CGAL_DIR .. "/../build-".._ACTION.."/include"
CGALLIB_DIR				= CGALPLAT_DIR .. "/../lib"
GMP_DIR						= CGAL_DIR .. "/../auxiliary/gmp/include"
GTE_DIR						= "K:/frameworks/src/GeometricTools_3_2/GTEngine/Include"
GTELIB_DIR					= GTE_DIR .. "/../_Output/v140/x64/Release"
GTELIBd_DIR				= GTE_DIR .. "/../_Output/v140/x64/Debug"




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
		
		files {	"shared/exports.*",
		}
		
		links {	"CgalBBoxLib", 
					"GteLib",
					"GTEngine.v14",
		}
		
		includedirs {	GLM_DIR,
		}
		
		libdirs {	BOOSTLIB_DIR,
					CGALLIB_DIR,
		}		
		
		configuration "Debug"
			libdirs {	GTELIBd_DIR,	
			}
			
		configuration "Release"
			libdirs {	GTELIB_DIR,	
			}
----------------------------------------------------------------
-- CGAL project
----------------------------------------------------------------
	project "CgalBBoxLib"
		kind "StaticLib"		
		flags { "StaticRuntime" }
		pchsource	("cgal/includes-cgal.cpp")
		pchheader	("includes-cgal.h")
		
		files {	"cgal/*",
		}
						
		includedirs {	CGAL_DIR, CGALPLAT_DIR,
							GMP_DIR,
							GLM_DIR,
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
		