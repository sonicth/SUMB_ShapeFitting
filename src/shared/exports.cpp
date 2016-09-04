#include "exports.h"
#include "../cgal/cgal-bbox.h"

using namespace std;

void fitTakeFour(Pts_t const& input, PointsPusher_f& pusher)
{
	const size_t POLY_NUM_VXS = 4;
	auto max_i = min(input.size(), POLY_NUM_VXS);

	//TODO copy sub-vector more efficiently
	for (int i = 0; i < max_i; ++i)
	{
		pusher(input[i]);
	}
}

void detectFitPoly(Pts_t const& input, PointsPusher_f &pusher)
{
	//fitTakeFour(input, pusher);

	Pts_t tmppts;
	doCgalStuff(input, tmppts);
	for (auto &pt:tmppts)
	{
		pusher(pt);
	}
}
