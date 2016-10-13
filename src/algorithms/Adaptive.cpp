/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
  
#include "includes-algorithms.h"
#include "AxisDistance.h"


namespace br = boost::range;
using namespace std;
using namespace glm;
namespace bg = boost::geometry;

//TODO use boost log
ConsoleWriter out;


void mapPolyAdaptive(Pts_t const &in_poly, Pts_t &out_poly)
{
	// first thing - clear out poly
	out_poly.clear();
}

