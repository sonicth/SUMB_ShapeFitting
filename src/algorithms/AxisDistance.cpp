/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
  
#include "includes-algorithms.h"
#include "AxisDistance.h"


namespace br = boost::range;
using namespace std;
using namespace glm;

/// Axis Aligned Bounding Box
/// @param	poly_pts	region poly
/// @param	vmin		vector of min x, y of the box
/// @param	vmax		vector of max x, y of the box
static 
void aabb(const Pts_t& poly_pts, dvec2 &vmin, dvec2 &vmax)
{
	// init min vector to the large, max vector to small
	auto large_val = std::numeric_limits<dvec2::value_type>::infinity();
	vmin = dvec2(large_val, large_val);
	vmax = dvec2(-large_val, -large_val);

	// storing function per point/vertex
	auto storeMinMax = [&vmin, &vmax](Pts_t::value_type const &pt)
	{
		vmin = glm::min(vmin, pt);
		vmax = glm::max(vmax, pt);
	};

	// apply functor to the point set
	for (auto &pt : poly_pts)
	{
		storeMinMax(pt);
	}
}

/// create CW AABB polygon 
/// @param	input	region poly
/// @param	output	AABB poly
static
void aabbPoly(const Pts_t& input, Pts_t& output)
{
	// must be empty!
	assert(output.empty());

	// quad
	output.reserve(4);
	// get min/max
	dvec2 vmin, vmax;
	aabb(input, vmin, vmax);

	// create AABB, CW direction
	output.push_back(vmin);
	output.push_back({ vmin.x, vmax.y });
	output.push_back(vmax);
	output.push_back({ vmax.x, vmin.y });
}

void mapPolyAxesFurthest(const Pts_t& input, Pts_t& output)
{
	assert(output.empty());
	output.clear();

	// create AABB
	Pts_t aabb_poly;
	aabbPoly(input, aabb_poly);
	
	// AABB min/max
	dvec2 vmin, vmax;
	//dont re-compute: aabb(input, vmin, vmax);
	// min and max are first and third vertices, independent of direction
	vmin = aabb_poly[0];
	vmax = aabb_poly[2];

	// centre of the AABB
	auto mid = (vmin + vmax) * 0.5;

	// for each AABB poly vertex:
	//	1. create ray from the centre and
	//	2. intersect with the input poly
	//TODO ...

	//.. for out 'return' AABB poly
	output = aabb_poly;
}
