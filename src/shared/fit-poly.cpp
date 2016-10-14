/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#include "fit-poly.h"
#include "../gte/gte-bbox.h"
#include "../algorithms/AxisDistance.h"
#include "../algorithms/Adaptive.h"

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

void detectFitPoly(Pts_t const& input, PointsPusher_f &pusher, EFitMethod which_method)
{
	Pts_t tmppts;

	switch (which_method)
	{
	case FIT_FIRST4:
		fitTakeFour(input, pusher);
		return;

	case FIT_AXES_FURTHEST: 
		fitPolyAxesFurthest(input, tmppts);
		break;

	case FIT_ADAPTIVE_ANGLE_THRESHOLD:
		fitPolyAdaptive(input, tmppts);
		break;

	case FIT_BBOX_GTE:
	default:
		fitPolyGTE(input, tmppts);
		break;
	
	}

	// copy temporary points
	for (auto &pt:tmppts)
	{
		pusher(pt);
	}

}
