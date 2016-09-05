#include "mbRubyUtils.h"
#include <boost/foreach.hpp>

void getShapePts(VALUE shape, Pts_t& pts)
{
	// convert to ruby DS
	auto iregion_num = RARRAY_LEN(shape);
	pts.reserve(iregion_num);

	for (int i = 0; i < iregion_num; ++i)
	{
		auto pt_v = rb_ary_entry(shape, i);
		auto x = NUM2DBL(rb_ary_entry(pt_v, 0));
		auto y = NUM2DBL(rb_ary_entry(pt_v, 1));
		Pts_t::value_type pt(x, y);
		pts.push_back(pt);
	}
}


VALUE setShapePts(Pts_t& pts)
{
	// Ruby array to store the points to
	VALUE pts_ar = rb_ary_new2(pts.size());

	int i = 0;
	BOOST_FOREACH(auto const &pt, pts)
	{
		// store coordiantes in the vector
		VALUE vecar = rb_ary_new2(2);
		rb_ary_store(vecar, 0, DBL2NUM(pt.x));
		rb_ary_store(vecar, 1, DBL2NUM(pt.y));

		// store current vector in the array of vectors
		rb_ary_store(pts_ar, i, vecar);
		++i;
	}

	return pts_ar;
}
