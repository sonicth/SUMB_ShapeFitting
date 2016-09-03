#include "mbRubyUtils.h"

void getShapePts(VALUE shape, Pts_t *pts)
{
	// convert to ruby
	auto iregion_num = RARRAY_LEN(shape);
	for (int i = 0; i < iregion_num; ++i)
	{
		auto pt_v = rb_ary_entry(shape, i);
		auto x = NUM2DBL(rb_ary_entry(pt_v, 0));
		auto y = NUM2DBL(rb_ary_entry(pt_v, 1));
		Pts_t::value_type pt(x, y);
		pts->push_back(pt);
	}
}
