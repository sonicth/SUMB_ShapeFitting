#include "exports.h"

using namespace std;

void detectFitPoly(Pts_t const& input, PointsPusher_f &pusher)
{
	const size_t POLY_NUM_VXS = 4;
	auto max_i = min(input.size(), POLY_NUM_VXS);

	//TODO copy sub-vector more efficiently
	for (int i = 0; i < max_i; ++i)
	{
		pusher(input[i]);
	}
;}
