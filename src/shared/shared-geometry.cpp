/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#include "shared-geometry.h"

Pts_t Box::toPoly() const
{
	return				// rectangle vertices clockwise
	{	o,				// SW (South-West or lower left corner)
		y,				// NW
		y + (x - o),	// NE; or x + (y - o)
		x				// SE
	};
}
