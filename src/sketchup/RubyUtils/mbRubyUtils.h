#pragma once

#include <glm/glm.hpp>
#include <boost/container/vector.hpp>
#include "RubyUtils/RubyLib.h"
#include <boost/foreach.hpp>


typedef boost::container::vector<glm::dvec2> Pts_t;


void getShapePts(VALUE shape, Pts_t *pts);

class ConsoleWriter
{
public:
	template <typename T>
	friend ConsoleWriter &operator<< (ConsoleWriter& cw, T const &v)
	{
		std::stringstream ss;
		ss << v;
		OutputDebugStringA(ss.str().c_str());
		return cw;
	}
};
