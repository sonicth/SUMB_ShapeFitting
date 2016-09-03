/*
 * ShapeFitting SU plugin
 * 
 * all plugin requests handled here
*/

#include "includes-shapefitting.h"

using namespace std;


ConsoleWriter out;

namespace SketchUp
{

	VALUE fitShape(VALUE v_module, VALUE v_shape)
	{
		try {
			// get points
			Pts_t pts;
			getShapePts(v_shape, &pts);

			if (pts.empty())
			{
				out << "fitShape(): empty shape!\n";
			}
			else
			{
				out << "fitShape(): shape passed with " << pts.size() << " points.\n";
			}

			int i = 0;
			VALUE pts_ar = rb_ary_new2(4);

			for (auto it = pts.begin(); it != pts.end(); ++it, ++i)
			{
				if (i < 4)
				{
					VALUE vecar = rb_ary_new2(2);
					rb_ary_store(vecar, 0, DBL2NUM(it->x));
					rb_ary_store(vecar, 1, DBL2NUM(it->y));
					rb_ary_store(pts_ar, i, vecar);
				}
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
}
