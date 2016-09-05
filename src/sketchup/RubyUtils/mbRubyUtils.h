#pragma once

#include "RubyUtils/RubyLib.h"
#include <boost/filesystem/path.hpp>
#include "../../shared/shared-geometry.h"
#include <sstream>

/// get points from ruby array
/// @param	shape	ruby array of points
/// @param	pts		where to store the points
void getShapePts(VALUE shape, Pts_t& pts);

/// store points to ruby array
/// @param	out_pts		input points
/// @return				ruby array where points are stored
VALUE setShapePts(Pts_t& pts);

/// class for stream-writing any type of variable to debugger console
class ConsoleWriter
{
	std::stringstream ss;

public:
	template <typename T>
	friend ConsoleWriter &operator<< (ConsoleWriter& cw, T const &v)
	{
		// clear previous state and contents
		cw.ss.clear();
		cw.ss.str(std::string());

		// output the variable
		cw.ss << v;

		// forward to Debugger Console
		OutputDebugStringA(cw.ss.str().c_str());

		// return object for cascading output
		return cw;
	}
};
