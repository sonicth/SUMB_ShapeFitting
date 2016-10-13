/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include "../shared/shared-geometry.h"

/// find a polygon (quad) which vertices are furthest from the axes
///		(alternatively nearest to axes corners)
/// @param input	vertices of the input region polygon
/// @param output	vertices of the mapped quad
void fitPolyAxesFurthest(const Pts_t& input, Pts_t& output);
