#include "includes-gte.h"
#include "gte-bbox.h"

// based on GTE library http://www.geometrictools.com/index.html
// some code adapted from <GTEngine>\Samples\Geometrics\MinimumAreaBox2D\MinimumAreaBox2DWindow.cpp

// GTE vector type
typedef gte::Vector2<double> V2_t;

// Compute the convex hull internally using arbitrary precision
// arithmetic.
using MABRational = gte::BSRational<gte::UIntegerAP32>;

namespace br = boost::range;
using namespace std;
using namespace gte;


void fitPolyGTE(const Pts_t& input, Pts_t& output)
{
	// transform to GTE representation
	std::vector<V2_t> vxs;
	br::transform(input, back_inserter(vxs), [&](auto &pt)
	{
		return V2_t{ pt.x, pt.y };
	});

	// compute the OB Box!
	MinimumAreaBox2<double, MABRational> mab2;
	auto obb = mab2(vxs.size(), &vxs[0]);

	// get vertices
	std::array<V2_t, 4> box_vxs;
	obb.GetVertices(box_vxs);
	
	// vertex order as found in MinimumAreaBox2DWindow.cpp
	int vx_map[] = { 0, 1, 3, 2 };

	// copy to internal representation
	output.clear();
	output.reserve(4);
	for (auto &vx_idx: vx_map)
	{
		auto &vx = box_vxs[vx_idx];
		output.push_back(Pts_t::value_type(vx[0], vx[1]));
	}
}
