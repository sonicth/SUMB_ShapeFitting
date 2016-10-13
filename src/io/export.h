/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include "../shared/shared-geometry.h"

 /// write a single polygon to obj file
 /// @param filename		filename where to write the polygon, better end with ".obj"!
 /// @param pts_in			list of vertices as input
void writeObj1(char const *filename, Pts_t const &pts_in);
