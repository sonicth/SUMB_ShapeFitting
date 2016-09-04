#pragma once

#include "RubyUtils/RubyLib.h"
#include <boost/filesystem/path.hpp>
#include "../../shared/shared-geometry.h"

void getShapePts(VALUE shape, Pts_t& pts);

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
