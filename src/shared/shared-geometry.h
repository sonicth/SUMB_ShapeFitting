/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include <glm/glm.hpp>
#include <boost/container/vector.hpp>

typedef glm::dvec2 Pt_t;

typedef boost::container::vector<Pt_t> Pts_t;
typedef boost::container::vector<int> Idxs_t;

struct Box
{
	Pt_t o;	/// south-west (lower left) "origin" point
	Pt_t x;	/// south-east (lower right)
	Pt_t y;	/// north-west (upper left)

	Pts_t toPoly() const;
};