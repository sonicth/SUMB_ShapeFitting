/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
//NOTE using TinyObjLoader code from https://github.com/syoyo/tinyobjloader 

//#include "includes-io.h"
#include "tiny_obj_loader.h"
#include "import.h"

void readObj1(char const * filename, Pts_t & pts_out)
{

	tinyobj::attrib_t attrib;
	std::vector<tinyobj::shape_t> shapes;
	//std::vector<tinyobj::material_t> materials;

	std::string err;
	bool ret = tinyobj::LoadObj(&attrib, &shapes, 0, &err, filename, 0, false);

	if (!ret)
		throw std::runtime_error(err);

	auto num_shapes = shapes.size();
	assert(num_shapes >= 1 || !"nead at least one shape");
	// just need the first shape!
	auto &mesh = shapes[0].mesh;
	auto num_pts = mesh.indices.size();
	assert(num_pts >= 3 || !"polygon needs to contain at least 3 vertices");
	pts_out.reserve(num_pts);

	for (auto &idx: mesh.indices)
	{
		auto x = attrib.vertices[idx.vertex_index * 3 + 0];
		auto z = attrib.vertices[idx.vertex_index * 3 + 2];
		pts_out.push_back({ x, z });
	}

	// remove closing point - duplicate!
	if (pts_out.front() == pts_out.back())
		pts_out.pop_back();

}
