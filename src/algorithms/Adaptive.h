/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include "../shared/shared-geometry.h"

/// @brief Detect Quad best fitting the input polygon
/// @param	in_poly		input polygon
/// @param	out_poly	detected quad polygon
void fitPolyAdaptive(Pts_t const &in_poly, Pts_t &out_poly);
