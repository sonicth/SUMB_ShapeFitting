/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
  
#include "includes-algorithms.h"
#include "AxisDistance.h"
#include "generic-algorithms.h"


using namespace std;
using namespace glm;
using namespace Algorithms;


/// adjacent edges thresholder based on dot product
class DotThresholder
{
	vector<double> dot_products;

public:
	/// @param	in_poly		input polygon
	explicit DotThresholder(Pts_t const &in_poly)
	{
		Pts_t unit_directions;
		// 1. compute normalised directions
		pair_rotated(in_poly, back_inserter(unit_directions), [](auto &pt1, auto &pt2) { return normalize(pt2 - pt1); });

		auto num_pts = in_poly.size();
		dot_products.reserve(num_pts);
		// 2. compute dot products between current and next
		for (int i = 0; i < num_pts; ++i)
		{
			auto i_prev = (i - 1 + num_pts) % num_pts;
			// get pair directions
			auto &dir_prev = unit_directions[i_prev];
			auto &dir_next = unit_directions[i];

			// for the current vertex: dot product between the previous and next edge
			dot_products.push_back(dot(dir_prev, dir_next));
		}
	}

	/// filter vertices that pass the threshold condition
	/// @param	threshold	dot product threshold - lower or equal is ok
	/// @return	indices of vertices that are corners (passed the threshold test)
	Idxs_t filter(double threshold)
	{
		// compute corners that are on the corner
		Idxs_t corner_idxs;
		int i = 0;
		for (auto &dp : dot_products)
		{
			if (dp <= threshold)
				corner_idxs.push_back(i);
			// next index
			++i;
		}
		return corner_idxs;
	}
};

/// adapted thresholder 
///	(NOT decorator since interface differs)
class AdaptedThresholder
	: public DotThresholder
{
	static const auto MAX_ITERATIONS = 10;
public:
	explicit AdaptedThresholder(Pts_t const &in_poly)
		: DotThresholder(in_poly)
	{
	}

	/// filter vertices adaptively until num_corners vertices is found
	/// @param	num_corners		number of vertices to search for
	/// @return	indices of vertices that are corners (those small enough with the num_corners count)
	Idxs_t filter(int num_corners)
	{
		// DOT product range
		dvec2 cos_range(-1, 1);

		Idxs_t idxs;
		int i = 0;
		// compute thresholds
		do
		{
			auto threshold = (cos_range.x + cos_range.y)*0.5;
			idxs = DotThresholder::filter(threshold);
			auto num_idxs = idxs.size();

			// adapt thresholds
			if (num_idxs > num_corners)
			{
				// more vertices classified as corners - 
				//	reduce threshold, increasing angle between two edges
				cos_range.y = threshold;
			}
			else if (num_idxs < num_corners)
			{
				// less vertices classified -
				//	increase threshold, allowing adjacent edges with greater angle in between
				cos_range.x = threshold;
			}

			//cerr << "**iteration " << i << endl;
			++i;
		} while (idxs.size() != num_corners && i < MAX_ITERATIONS);

		if (i == MAX_ITERATIONS && idxs.size() != num_corners)
			throw std::runtime_error("failed to detect quad shape!");

		return idxs;

	}
};


void fitPolyAdaptive(Pts_t const &in_poly, Pts_t &out_poly)
{
	const auto NUM_CORNERS = 4;
	// preconditions: input has more than 4 corners, otherwise there is no paint
	assert(in_poly.size() > NUM_CORNERS);
	// first thing - clear out poly
	out_poly.clear();

	// find corner indices
	AdaptedThresholder thresholder(in_poly);
	auto idxs = thresholder.filter(NUM_CORNERS);

	// using indices put found vertices into a polygon
	for (auto &idx: idxs)
	{
		out_poly.push_back(in_poly[idx]);
	}
}

