/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 * 
 * all plugin requests handled here
 * 
 *   Load this module from Ruby using:
 *   require 'mb_shape_fitting/win_x64/SUMB_ShapeFitting'
*/

#include "includes-shapefitting.h"

using namespace std;
namespace dll = boost::dll;

// Debugger console writer
ConsoleWriter out;

namespace SketchUp
{
	SoPtr_t fitter_lib;

	/// Ruby Interface function for fitting a polygon
	VALUE fitShape(VALUE v_module, VALUE v_shape)
	{
		try {
			// get points
			Pts_t pts, out_pts;
			getShapePts(v_shape, pts);

			if (pts.empty())
			{
				out << "fitShape(): empty shape!\n";
			}
			else
			{
				out << "fitShape(): shape passed with " << pts.size() << " points.\n";
			}
			
			// get function..
			auto fit_fun = fitter_lib->get<void(Pts_t const &, PointsPusher_f, EFitMethod)>("detectFitPoly");
			// create pusher..
			//	NOTE backinserter would not work as it would still use the local heap
			PointsPusher_f pusher = [&out_pts](Pts_t::value_type const &pt) { out_pts.push_back(pt); };
			
			// get points!
			fit_fun(pts, pusher, FIT_AXES_FURTHEST);

			// write to ruby array
			auto pts_ar = setShapePts(out_pts);
			return pts_ar;
		}
		catch (std::exception const &e) {
			// error has occured
			auto msg = e.what();
			out << "***fitShape() exception: " << msg << "***\n";

			VALUE empty = rb_ary_new2(0);
			return empty;
		}
	} // fun fitshape

} // namespace sketchup


// the Init_[Name] function creates Ruby module [Name] when called
extern "C"
void Init_SUMB_ShapeFitting()
{
	VALUE mod_val_root = rb_define_module("MikeBasille");
	VALUE mod_val = rb_define_module_under(mod_val_root, "ShapeFitting");

	rb_define_const(mod_val, "CEXT_VERSION", GetRubyInterface("1.0.0"));
	
	// Ruby will see these functions:
	rb_define_module_function(mod_val, "suFitShape", VALUEFUNC(SketchUp::fitShape), 1);

	// algorithms are stored at this DyLib
	char const fitter_dylibname[] = "ShapeFittingDyLib.dll";
	// ..open this DyLib
	auto fitter_lib_path = getDyLibPath(fitter_dylibname);
	SketchUp::fitter_lib = boost::make_shared<dll::shared_library>(fitter_lib_path);
}
