/* use as follows
c = SUMB_ShapeFitting.fitShape
*/
#include "includes-shapefitting.h"

//TODO separate
class ConsoleWriter
{
public:
	template <typename T>
	friend ConsoleWriter &operator<< (ConsoleWriter& cw, T const &v)
	{
		std::stringstream ss;
		ss << v;
		OutputDebugStringA(ss.str().c_str());
		return cw;
	}
};

using namespace std;


ConsoleWriter out;

namespace SketchUp
{

	VALUE fitShape(VALUE X, VALUE data)
	{
		try {
			out << "fitShape() called!\n";
			rb_warn("ShapeFitting plugin...");

			VALUE something = rb_ary_new2(1);
			return something;
		}
		catch (std::exception const &e) {
			// error has occured
			auto msg = e.what();
			out << "fitShape() error: " << msg;

			VALUE empty = rb_ary_new2(0);
			return empty;
		}
	}
}


// Load this module from Ruby using:
//   require 'SUMB_ShapeFitting'
extern "C"
void Init_SUMB_ShapeFitting()
{
	VALUE mod_val_root = rb_define_module("MikeBasille");
	VALUE mod_val = rb_define_module_under(mod_val_root, "ShapeFitting");

	rb_define_const(mod_val, "CEXT_VERSION", GetRubyInterface("1.0.0"));
	rb_define_module_function(mod_val, "suFitShape", VALUEFUNC(SketchUp::fitShape), 1);
}
