#include "includes-cgal.h"
#include "cgal-bbox.h"

//copied from http://doc.cgal.org/latest/Bounding_volumes/group__PkgBoundingVolumes.html

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_2 Point_2;
typedef Kernel::Line_2 Line_2;
typedef CGAL::Polygon_2<Kernel> Polygon_2;

namespace br = boost::range;
using namespace std;

void fitPolyCGAL(const Pts_t& input, Pts_t &output)
{
	Polygon_2 p;

	// convert internal to CGAL representation
	br::transform(input, back_inserter(p), [&](auto &pt)
	{
		return Point_2(pt.x, pt.y);
	});

	// compute the minimal enclosing rectangle p_m of p
	Polygon_2 p_m;
	CGAL::min_rectangle_2(
		p.vertices_begin(), p.vertices_end(), std::back_inserter(p_m)
			);

	// must be a quad!
	assert(p_m.size() == 4);
	output.clear(); output.reserve(p_m.size());

	// convert from CGAL to internal (GLM) format
	std::transform(
		p_m.vertices_begin(), p_m.vertices_end(),
		std::back_inserter(output),
		[](auto &cgal_pt) { return Pts_t::value_type(cgal_pt.x(), cgal_pt.y()); }
			);
}
