/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 

#include "Adaptive.h"
#include "../io/import.h"
#include "../io/export.h"
#include <iostream>

#define BOOST_TEST_MODULE My Test
//#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>
//#include <boost/test/included/unit_test.hpp>


namespace bt = boost::unit_test;
using namespace std;


//#define BOOST_LIB_TOOLSET "vc120"
//#define BOOST_AUTO_TEST_MAIN
//#define BOOST_TEST_MODULE MyTest
//#include <boost/test/unit_test.hpp>
//
//BOOST_AUTO_TEST_CASE(my_test)
//{
//	BOOST_CHECK(1 == 2);
//}

struct ArgsFixture
{
	const std::string base_path = "../../sample_geometry/";
	vector<std::string> filepath_list;
	vector<std::string> filename_list;
	void addFile(char const *filename)
	{
		filename_list.push_back(filename);
		filepath_list.push_back(base_path + filename);
	}

	ArgsFixture()
	{
		// add any additional files from cmd args
		auto num_files = bt::framework::master_test_suite().argc - 1;
		cout << "number of files: " << num_files << endl;
		for (int i = 1; i <= num_files; ++i)
		{
			addFile(bt::framework::master_test_suite().argv[i]);
			
		}
	}
};

BOOST_FIXTURE_TEST_CASE(adaptive_test, ArgsFixture)
{
	//using tt = boost::test_tools;
	namespace tt = boost::test_tools;

	Pts_t poly_in, poly_out;

	BOOST_REQUIRE(!filepath_list.empty());

	int i = 0;
	for (auto &filepath : filepath_list)
	{
		// read and test
		readObj1(filepath.c_str(), poly_in);
		// dont bother with quads (...and lower)
		if (poly_in.size() <= 4)
			continue;
		BOOST_TEST(poly_in.size() >= 4);

		// compute output poly - quad
		try
		{
			fitPolyAdaptive(poly_in, poly_out);
			cout << "ok\n";
		} catch (std::exception const &ex)
		{
			cout << "failed for file " << filename_list[i] << endl;
		}
		
		BOOST_TEST(poly_out.size() == 4);

		// write out!
		string filename = "output" + to_string(i) + "_" + filename_list[i];
		writeObj1(filename.c_str(), poly_out);
		++i;
	}
}
