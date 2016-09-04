/*
 * ShapeFitting SU plugin
 * 
 * all plugin requests handled here
*/

#include "includes-shapefitting.h"

using namespace std;
namespace dll = boost::dll;


ConsoleWriter out;

namespace SketchUp
{
	SoPtr_t fitter_lib;

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
			auto fit_fun = fitter_lib->get<void(Pts_t const &, PointsPusher_f)>("detectFitPoly");
			// create pusher..
			//	NOTE backinserter would not work as it would still use the local heap
			PointsPusher_f pusher = [&out_pts](Pts_t::value_type const &pt) { out_pts.push_back(pt); };
			// get points!
			fit_fun(pts, pusher);

			//TODO refactor to setShapePts
			// write to ruby array
			VALUE pts_ar = rb_ary_new2(out_pts.size());
			int i = 0;
			BOOST_FOREACH(auto const &pt, out_pts)
			{
				VALUE vecar = rb_ary_new2(2);
				rb_ary_store(vecar, 0, DBL2NUM(pt.x));
				rb_ary_store(vecar, 1, DBL2NUM(pt.y));
				rb_ary_store(pts_ar, i, vecar);
				++i;
			}

			return pts_ar;
		}
		catch (std::exception const &e) {
			// error has occured
			auto msg = e.what();
			out << "fitShape() error: " << msg;

			VALUE empty = rb_ary_new2(0);
			return empty;
		}
	} // fun fitshape

} // namespace sketchup


// Load this module from Ruby using:
//   require 'mb_shape_fitting/win_x64/SUMB_ShapeFitting'
extern "C"
void Init_SUMB_ShapeFitting()
{
	VALUE mod_val_root = rb_define_module("MikeBasille");
	VALUE mod_val = rb_define_module_under(mod_val_root, "ShapeFitting");

	rb_define_const(mod_val, "CEXT_VERSION", GetRubyInterface("1.0.0"));
	rb_define_module_function(mod_val, "suFitShape", VALUEFUNC(SketchUp::fitShape), 1);

	char const fitter_dylibname[] = "ShapeFittingDyLib.dll";
	// open dynamic library
	auto fitter_lib_path = getDyLibPath(fitter_dylibname);
	SketchUp::fitter_lib = boost::make_shared<dll::shared_library>(fitter_lib_path);
}
