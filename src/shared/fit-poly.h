/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

// dll
#include <boost/dll.hpp>

// standard
#include "../shared/shared-geometry.h"
#include <boost/function.hpp>

#include <boost/container/string.hpp>
#include <boost/container/flat_map.hpp>

#define DLL extern "C" BOOST_SYMBOL_EXPORT 
#define DLL_CPP BOOST_SYMBOL_EXPORT 

/// pointer to DyLib interface object
typedef boost::shared_ptr<boost::dll::shared_library> SoPtr_t;

/// pusher functor
///	-during creation stores reference to the local heap (closure) container
/// -when called addes points to the store contailer
typedef boost::function<void(Pts_t::value_type const &)> PointsPusher_f;

/// Various Methods for fitting a polygon
enum EFitMethod
{
	FIT_BBOX,			///< OBB using GTE library OR AABB
	FIT_AXES_CORNERS,	///< vertices that are furthers from the two axes, or clostest to the two axes mid-line
	FIT_ADAPTIVE_ANGLE_THRESHOLD,		///< adaptive angle threshold
	FIT_FIRST4,			///< first 4 vertices form the output
	FIT_METHOD_MAX
};

enum EBoxType
{
	BOX_AABB,
	BOX_OBB,
	BOX_TYPE_MAX
};


struct FitParams_t
{
	EFitMethod	method;
	EBoxType	box_type;

	/// set parameters in ctor
	/// @brief parameter values changed against bounds and default values are set if outside of the bounds
	///		template arguments used to allow convertion to numeric values
	template <typename T, typename U>
	FitParams_t(T method_, U box_type_)
		: method(static_cast<EFitMethod>(static_cast<int>(method_ < 0 || method_ >= FIT_METHOD_MAX ? FIT_BBOX : method_))),
		  box_type(static_cast<EBoxType>(static_cast<int>(box_type_ < 0 || box_type_ >= BOX_TYPE_MAX ? BOX_AABB : box_type_)))
	{
	}
};


/// fit polygon inside an given input polygon
/// @param	input		points of the input polygon
/// @param	pusher		functor, which when called will add points to the output or fitted polygon
DLL
void detectFitPoly(Pts_t const &input, PointsPusher_f &pusher, FitParams_t params);

/// retrieve full path of the dynamic library - from the current module
/// @param dylib_name		name of the library
/// @return					library path
inline boost::filesystem::path getDyLibPath(char const *dylib_name)
{
	auto su_plugin_path = boost::dll::this_line_location();
	auto dylib_path = su_plugin_path.parent_path() / dylib_name;

	return dylib_path;
}