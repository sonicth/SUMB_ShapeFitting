/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 
//#include "includes-io.h"
#include "tiny_obj_loader.h"
#include "export.h"
#include <fstream>
#include <iostream>

using namespace std;

void writeObj1(char const * filename, Pts_t const & pts_in)
{	
	ofstream of(filename);

	if (!of.is_open())
	{
		std::cerr << "error: cannot open file '" << filename << "' for writing." << std::endl;
		throw std::runtime_error(string("failed to open file ") + filename);
	}

	// super-quick write of obj!

	// write vertices
	for (auto &pt:pts_in) { of << "v " << pt.x << " " << 0 << " " << pt.y << "\n"; 	}
	// write indices
	auto num_indices = pts_in.size();
	of << "f "; for (int idx = 1; idx <= num_indices; ++idx) of << idx << " "; of << "\n";


}
