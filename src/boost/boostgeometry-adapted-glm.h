/*
 * copyright 2016 mike vasiljevs (contact@michaelvasiljevs.com)
 * 
 * GLM interface for Boost Geometry
 */
/// Adapt GLM data structures to Boost Geometry
///
///	29sep2016: 2D vertex/point (glm::tvec2) adapted
 
#pragma once

#include <glm/glm.hpp>

#include <boost/geometry/core/access.hpp>
#include <boost/geometry/core/cs.hpp>
#include <boost/geometry/core/coordinate_dimension.hpp>
#include <boost/geometry/core/coordinate_type.hpp>
#include <boost/geometry/core/tags.hpp>


 // adapt glm vectors to geometry algorithms
namespace boost {
	namespace geometry {
		namespace traits {

			template <typename CoordinateType>
			struct tag<glm::tvec2<CoordinateType>>
			{
				typedef point_tag type;
			};

			template <typename CoordinateType>
			struct coordinate_type<glm::tvec2<CoordinateType>>
			{
				typedef CoordinateType type;
			};

			template <typename CoordinateType>
			struct coordinate_system<glm::tvec2<CoordinateType>>
			{
				typedef cs::cartesian type;
			};

			template <typename CoordinateType>
			struct dimension<glm::tvec2<CoordinateType>>
				: boost::mpl::int_<2>	// "2D"
			{};

			// get x
			template <typename CoordinateType>
			struct access<glm::tvec2<CoordinateType>, 0>
			{
				//typedef coordinate_type<IndexedPoint> T;
				typedef glm::tvec2<CoordinateType> point_type;

				static inline CoordinateType get(point_type const& p)
				{
					return p.x;
				}

				static inline void set(point_type& p, CoordinateType const& value)
				{
					p.x = value;
				}
			};

			// get y
			template <typename CoordinateType>
			struct access<glm::tvec2<CoordinateType>, 1>
			{
				//typedef coordinate_type<IndexedPoint> T;
				typedef glm::tvec2<CoordinateType> point_type;

				static inline CoordinateType get(point_type const& p)
				{
					return p.y;
				}

				static inline void set(point_type& p, CoordinateType const& value)
				{
					p.y = value;
				}
			};



		} // end namespace traits
	} // end namespace geometry
} // end namespace boost
