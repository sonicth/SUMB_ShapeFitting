/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
  
#include "includes-algorithms.h"
#include "AxisDistance.h"
#include "generic-algorithms.h"


namespace br = boost::range;
using namespace std;
using namespace glm;
namespace bg = boost::geometry;
using namespace Algorithms;

//TODO use boost log
ConsoleWriter out;


/// compute vertices that pass the given (dont product) threshold
/// @param	in_poly		input polygon
/// @param	threshold	dot product threshold - lower or equal is ok
/// @return	vector of bool, true if vertex has passed the threshold
vector<bool> computeThresholds(Pts_t const &in_poly, double threshold)
{
	// 1. compute normalised directions
	Pts_t unit_directions;
	pair_rotated(in_poly, back_inserter(unit_directions), [](auto &pt1, auto &pt2) { return normalize(pt2 - pt1); });

	// 2. compute dot products between current and next
	auto num_pts = in_poly.size();
	vector<double> dot_products(num_pts);

	for (int i = 0; i < num_pts; ++i)
	{
		auto i_prev = (i - 1 + num_pts) % num_pts;
		// get pair directions
		auto &dir_prev = unit_directions[i_prev];
		auto &dir_next = unit_directions[i];

		// for the current vertex: dot product between the previous and next edge
		dot_products[i] = dot(dir_prev, dir_next);
	}

	// 3. compute corners that are on the corner
	vector<bool> is_corner(num_pts);
	for (int i = 0; i < num_pts; ++i)
	{
		is_corner[i] = dot_products[i] <= threshold;
	}

	return is_corner;
}


void mapPolyAdaptive(Pts_t const &in_poly, Pts_t &out_poly)
{
	//NOTE could be constant
	//		or use constexpr math functions, like https://github.com/Morwenn/static_math
	auto DOT_THRESHOLD = cos(M_PI / 6);

	// first thing - clear out poly
	out_poly.clear();

	// compute thresholds
	auto is_corner_thresholds = computeThresholds(in_poly, DOT_THRESHOLD);
	int i = 0;
	for (auto &pt: in_poly)
	{
		if (is_corner_thresholds[i])
			out_poly.push_back(pt);
		// increment i
		++i;
	}

}

