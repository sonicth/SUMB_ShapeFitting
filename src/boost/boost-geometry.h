/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

// use glm:: vectors with Boost Geometry
#include "boostgeometry-adapted-glm.h"

#include <boost/geometry/geometry.hpp>

namespace Mb
{
	auto const ORIENTATION = true;

	// point types
	using point = glm::dvec2;
	using Points_t = std::vector<point>;

	// polygon types
	using poly = boost::geometry::model::ring<point, ORIENTATION, false>;
	using poly_withholes = boost::geometry::model::polygon<point, ORIENTATION, false>;
	using mpoly = boost::geometry::model::multi_polygon<poly_withholes>;
	using box = boost::geometry::model::box<point>;

	// segment types
	using segment = boost::geometry::model::segment<point>;

	// polyline types
	using polyline = boost::geometry::model::linestring<point>;

	// functions

	/// intersctions of polygon and segment
	/// @param	p		polygon
	/// @param	s		segment
	/// @return			intersection points
	Points_t intersectWithPoly(poly const &p, segment s);

}


