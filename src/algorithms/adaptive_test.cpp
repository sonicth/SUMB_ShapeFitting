/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * ShapeFitting SU plugin
 */
 


#include "includes-test.h"

#define BOOST_TEST_MODULE My Test
//#define BOOST_TEST_DYN_LINK
#include <boost/test/unit_test.hpp>
//#include <boost/test/included/unit_test.hpp>


namespace bt = boost::unit_test;


//#define BOOST_LIB_TOOLSET "vc120"
//#define BOOST_AUTO_TEST_MAIN
//#define BOOST_TEST_MODULE MyTest
//#include <boost/test/unit_test.hpp>
//
//BOOST_AUTO_TEST_CASE(my_test)
//{
//	BOOST_CHECK(1 == 2);
//}

BOOST_AUTO_TEST_CASE(adaptive_test)
{
	//using tt = boost::test_tools;
	namespace tt = boost::test_tools;

	Pts_t poly_in, poly_out;

	// TODO get input polygon
	BOOST_TEST(poly_in.size() >= 4);

	// compute output poly - quad
	mapPolyAdaptive(poly_in, poly_out);

	BOOST_TEST(poly_out.size() == 4);
}
