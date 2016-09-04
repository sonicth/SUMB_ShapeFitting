#pragma once

// dll
#include <boost/dll.hpp>
//#include <boost/dll/alias.hpp> 

// standard
#include "../shared/shared-geometry.h"
#include <boost/function.hpp>

#define DLL extern "C" BOOST_SYMBOL_EXPORT 
#define DLL_CPP BOOST_SYMBOL_EXPORT 

typedef boost::shared_ptr<boost::dll::shared_library> SoPtr_t;

typedef boost::function<void(Pts_t::value_type const &)> PointsPusher_f;

enum EFitMethod
{
	FIT_FIRST4,
	FIT_BBOX_CGAL,
	FIT_BBOX_GTE,
};

DLL
void detectFitPoly(Pts_t const &input, PointsPusher_f &pusher, EFitMethod which_method = FIT_BBOX_GTE);


inline boost::filesystem::path getDyLibPath(char const *dylib_name)
{
	//auto path = dll::program_location();
	auto su_plugin_path = boost::dll::this_line_location();
	auto dylib_path = su_plugin_path.parent_path() / dylib_name;

	return dylib_path;
}