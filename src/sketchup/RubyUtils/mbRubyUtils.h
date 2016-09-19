/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include "RubyUtils/RubyLib.h"
//#include <boost/filesystem/path.hpp>
#include "../../shared/shared-geometry.h"

/// get points from ruby array
/// @param	shape	ruby array of points
/// @param	pts		where to store the points
void getShapePts(VALUE shape, Pts_t& pts);

/// store points to ruby array
/// @param	out_pts		input points
/// @return				ruby array where points are stored
VALUE setShapePts(Pts_t& pts);

