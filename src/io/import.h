/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include "../shared/shared-geometry.h"

/// read a single polygon from obj file
/// @param filename		filename with polygon eding with ".obj"
/// @param pts_out		where to write vertex data
void readObj1(char const *filename, Pts_t &pts_out);
