/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
  
#include "includes-algorithms.h"
#include "AxisDistance.h"
#include "Adaptive.h"


namespace br = boost::range;
using namespace std;
using namespace glm;
namespace bg = boost::geometry;

//TODO use boost log
ConsoleWriter out;

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

::Box boxAabb(const Pts_t& input)
{
	dvec2 vmin, vmax;
	aabb(input, vmin, vmax);

	auto vsize = vmax - vmin;

	return {vmin, vmin + Pt_t{ vsize.x, 0 }, vmin + Pt_t{ 0, vsize.y } };
}

void fitPolyAxesFurthest(const Pts_t& input, const Box& box, Pts_t& output)
{
	assert(output.empty());
	output.clear();

	Mb::poly pinput;
	bg::append(pinput, input);
	
	//// bg aabb
	//Mb::box b;
	//bg::envelope(pinput, b);

	Mb::point centre;
	bg::centroid(pinput, centre);

	output.clear();
	for (auto &corner:box.toPoly())
	{
		// ray from the centre to the corner of the bounding box (axis junction)
		Mb::segment ray{centre, corner};

		// 'cast' ray into the polygon boundary,
		//	there should be only one hit
		auto isections = Mb::intersectWithPoly(pinput, ray);
		assert(!isections.empty());

		if (isections.size() > 1)
			out << "warning: more than one intersections found!\n";

		// use hits as polygon corners
		output.push_back(isections.front());

	}
	//bg::centroid()
}
