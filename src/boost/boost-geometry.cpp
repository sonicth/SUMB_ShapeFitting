/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
#include "includes-algorithms.h"

namespace bg = boost::geometry;

namespace Mb
{

	Points_t intersectWithPoly(poly const &p, segment s)
	{
		// polygon edges as polyline...
		// edd edges of the polygon, not including the final edge
		polyline p_line(p.begin(), p.end());
		// closing edge, between first and last vertices
		p_line.push_back(*p.begin());
		
		// segment as polyline
		polyline s_line{ s.first, s.second };

		// intersect them
		Points_t isections;
		bg::intersection(p_line, s_line, isections);

		return isections;
	}

}


