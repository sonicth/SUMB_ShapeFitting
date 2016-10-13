#pragma once
#include <utility>	// for std::make_pair

namespace Algorithms
{
	/// pair up elements
	/// output should have ONE less elements then input
	template <typename RangeT, typename OutputIt, typename UnaryOperation>
	OutputIt pairup(RangeT const& r, OutputIt o, UnaryOperation uop)
	{
		auto b = r.begin();
		auto e = r.end();

		if (b != e)
		{
			// there should be more than one element!
			auto first = b;
			++b;

			while (b != e)
			{
				*o++ = uop(*first, *b);

				first = b;
				++b;
			}
		}

		return o;
	}

	template <typename RangeT, typename OutputIt/*, typename UnaryOperation*/>
	OutputIt pairup(RangeT const &r, OutputIt o)
	{
		typedef RangeT::value_type T;
		return pairup(r, o, [](T const &x1, T const &x2){ return make_pair(x1, x2); });
	}

	template <typename RangeT, typename OutputIt, typename UnaryOperation>
	OutputIt pair_rotated(RangeT const &r, OutputIt o, UnaryOperation uop)
	{
		typedef std::vector<typename RangeT::value_type> container_type;
		container_type r_copy(r.begin(), r.end());

		if (r_copy.empty())
			return o;

		// add 'rotation' to the set
		r_copy.push_back(r_copy.front());

		return pairup(r_copy, o, uop);
	}

	template <typename RangeT, typename OutputIt>
	OutputIt pair_rotated(RangeT r, OutputIt o)
	{
		typedef RangeT::value_type T;
		return pair_rotated(r, o, [](T const &x1, T const &x2){ return make_pair(x1, x2); });
	}

	/// find indices of the operations where f() evaluate to true
	template <typename RangeT, typename OutputIt, typename UnaryOperation>
	OutputIt find_indices_copy(RangeT const &r, OutputIt o, UnaryOperation f)
	{
		auto b = r.begin(),
			e = r.end();
		int idx = 0;
		while (b != e)
		{
			if (f(*b))
			{
				*o++ = idx;
			}
			++idx;
			++b;
		}

		return o;
	}
}
