/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
#pragma once

#include <Windows.h>
#undef min
#undef max

#include <sstream>


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