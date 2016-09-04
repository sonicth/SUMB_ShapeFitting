#include "includes-cgal.h"
#include "cgal-bbox.h"


//copied from http://doc.cgal.org/latest/Bounding_volumes/group__PkgBoundingVolumes.html

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_2 Point_2;
typedef Kernel::Line_2 Line_2;
typedef CGAL::Polygon_2<Kernel> Polygon_2;
//typedef CGAL::Random_points_in_square_2<Point_2> Generator;

namespace br = boost::range;
using namespace std;

void doCgalStuff(const Pts_t& input, Pts_t &output)
{
	Polygon_2 p;

	//// build a random convex 20-gon p
	//CGAL::random_convex_set_2(20, std::back_inserter(p), Generator(100.0));
	//std::cout << p << std::endl;

	// turn points into CGAL type
	//typedef Pts_t::value_type Pt;
	//auto n = input.size();
	//Pt middle;
	//for (auto &pt: input)
	//{
	//	middle += pt;
	//}
	//middle /= n;
	//auto out_pt = (middle + pt) * 0.5;

	br::transform(input, back_inserter(p), [&](auto &pt)
	{
		return Point_2(pt.x, pt.y);
	});

	// compute the minimal enclosing rectangle p_m of p
	Polygon_2 p_m;
	CGAL::min_rectangle_2(
	//CGAL::min_parallelogram_2(
		p.vertices_begin(), p.vertices_end(), std::back_inserter(p_m)
			);

	output.clear(); output.reserve(p_m.size());

	std::transform(
		p_m.vertices_begin(), p_m.vertices_end(),
		//p.vertices_begin(), p.vertices_end(),
		std::back_inserter(output),
		[](auto &cgal_pt) { return Pts_t::value_type(cgal_pt.x(), cgal_pt.y()); }
			);

}
