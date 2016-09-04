#include "includes-cgal.h"
#include "cgal-bbox.h"

//copied from http://doc.cgal.org/latest/Bounding_volumes/group__PkgBoundingVolumes.html

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_2 Point_2;
typedef Kernel::Line_2 Line_2;
typedef CGAL::Polygon_2<Kernel> Polygon_2;
typedef CGAL::Random_points_in_square_2<Point_2> Generator;
int doCgalStuff()
{
	// build a random convex 20-gon p
	Polygon_2 p;
	CGAL::random_convex_set_2(20, std::back_inserter(p), Generator(1.0));
	std::cout << p << std::endl;
	// compute the minimal enclosing parallelogram p_m of p
	Polygon_2 p_m;
	CGAL::min_parallelogram_2(
		p.vertices_begin(), p.vertices_end(), std::back_inserter(p_m));
	std::cout << p_m << std::endl;
	return 0;
}
