//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <vector>

// template <class InputIter> vector(InputIter first, InputIter last,
//                                   const allocator_type& a);

#include <vector>
#include <cassert>
#include <cstddef>

#include "test_macros.h"
#include "test_iterators.h"
#include "test_allocator.h"
#include "min_allocator.h"
#include "asan_testing.h"
#if TEST_STD_VER >= 11
#  include "emplace_constructible.h"
#  include "container_test_types.h"
#endif

template <class C, class Iterator, class A>
TEST_CONSTEXPR_CXX20 void test(Iterator first, Iterator last, const A& a) {
  C c(first, last, a);
  LIBCPP_ASSERT(c.__invariants());
  assert(c.size() == static_cast<std::size_t>(std::distance(first, last)));
  LIBCPP_ASSERT(is_contiguous_container_asan_correct(c));
  for (typename C::const_iterator i = c.cbegin(), e = c.cend(); i != e; ++i, ++first)
    assert(*i == *first);
}

#if TEST_STD_VER >= 11

template <class T>
struct implicit_conv_allocator : min_allocator<T> {
  TEST_CONSTEXPR implicit_conv_allocator(void*) {}
  TEST_CONSTEXPR implicit_conv_allocator(const implicit_conv_allocator&) = default;

  template <class U>
  TEST_CONSTEXPR implicit_conv_allocator(implicit_conv_allocator<U>) {}
};

#endif

TEST_CONSTEXPR_CXX20 void basic_tests() {
  {
    int a[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 1, 0};
    int* an = a + sizeof(a) / sizeof(a[0]);
    std::allocator<int> alloc;
    test<std::vector<int> >(cpp17_input_iterator<const int*>(a), cpp17_input_iterator<const int*>(an), alloc);
    test<std::vector<int> >(forward_iterator<const int*>(a), forward_iterator<const int*>(an), alloc);
    test<std::vector<int> >(bidirectional_iterator<const int*>(a), bidirectional_iterator<const int*>(an), alloc);
    test<std::vector<int> >(random_access_iterator<const int*>(a), random_access_iterator<const int*>(an), alloc);
    test<std::vector<int> >(a, an, alloc);
  }
#if TEST_STD_VER >= 11
  {
    int a[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 1, 0};
    int* an = a + sizeof(a) / sizeof(a[0]);
    min_allocator<int> alloc;
    test<std::vector<int, min_allocator<int> > >(
        cpp17_input_iterator<const int*>(a), cpp17_input_iterator<const int*>(an), alloc);
    test<std::vector<int, min_allocator<int> > >(
        forward_iterator<const int*>(a), forward_iterator<const int*>(an), alloc);
    test<std::vector<int, min_allocator<int> > >(
        bidirectional_iterator<const int*>(a), bidirectional_iterator<const int*>(an), alloc);
    test<std::vector<int, min_allocator<int> > >(
        random_access_iterator<const int*>(a), random_access_iterator<const int*>(an), alloc);
    test<std::vector<int, min_allocator<int> > >(a, an, alloc);
    test<std::vector<int, implicit_conv_allocator<int> > >(a, an, nullptr);
  }
  {
    int a[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 1, 0};
    int* an = a + sizeof(a) / sizeof(a[0]);
    safe_allocator<int> alloc;
    test<std::vector<int, safe_allocator<int> > >(
        cpp17_input_iterator<const int*>(a), cpp17_input_iterator<const int*>(an), alloc);
    test<std::vector<int, safe_allocator<int> > >(
        forward_iterator<const int*>(a), forward_iterator<const int*>(an), alloc);
    test<std::vector<int, safe_allocator<int> > >(
        bidirectional_iterator<const int*>(a), bidirectional_iterator<const int*>(an), alloc);
    test<std::vector<int, safe_allocator<int> > >(
        random_access_iterator<const int*>(a), random_access_iterator<const int*>(an), alloc);
    test<std::vector<int, safe_allocator<int> > >(a, an, alloc);
  }

  // Regression test for https://github.com/llvm/llvm-project/issues/46841
  {
    min_allocator<int> alloc;
    std::vector<int, min_allocator<int> > v1({}, forward_iterator<const int*>{}, alloc);
    std::vector<int, min_allocator<int> > v2(forward_iterator<const int*>{}, {}, alloc);
  }
#endif
}

TEST_CONSTEXPR_CXX20 void emplaceable_concept_tests() {
#if TEST_STD_VER >= 11
  int arr1[] = {42};
  int arr2[] = {1, 101, 42};
  {
    using T     = EmplaceConstructible<int>;
    using It    = forward_iterator<int*>;
    using Alloc = std::allocator<T>;
    Alloc a;
    {
      std::vector<T> v(It(arr1), It(std::end(arr1)), a);
      assert(v[0].value == 42);
    }
    {
      std::vector<T> v(It(arr2), It(std::end(arr2)), a);
      assert(v[0].value == 1);
      assert(v[1].value == 101);
      assert(v[2].value == 42);
    }
  }
  {
    using T     = EmplaceConstructibleAndMoveInsertable<int>;
    using It    = cpp17_input_iterator<int*>;
    using Alloc = std::allocator<T>;
    Alloc a;
    {
      std::vector<T> v(It(arr1), It(std::end(arr1)), a);
      assert(v[0].copied == 0);
      assert(v[0].value == 42);
    }
    {
      std::vector<T> v(It(arr2), It(std::end(arr2)), a);
      assert(v[0].value == 1);
      assert(v[1].value == 101);
      assert(v[2].copied == 0);
      assert(v[2].value == 42);
    }
  }
#endif
}

void test_ctor_under_alloc() {
  int arr1[] = {42};
  int arr2[] = {1, 101, 42};
#if TEST_STD_VER >= 11
  {
    using C     = TCT::vector<>;
    using It    = forward_iterator<int*>;
    using Alloc = typename C::allocator_type;
    Alloc a;
    {
      ExpectConstructGuard<int&> G(1);
      C v(It(arr1), It(std::end(arr1)), a);
    }
    {
      ExpectConstructGuard<int&> G(3);
      C v(It(arr2), It(std::end(arr2)), a);
    }
  }
  {
    using C     = TCT::vector<>;
    using It    = cpp17_input_iterator<int*>;
    using Alloc = typename C::allocator_type;
    Alloc a;
    {
      ExpectConstructGuard<int&> G(1);
      C v(It(arr1), It(std::end(arr1)), a);
    }
    {
      //ExpectConstructGuard<int&> G(3);
      //C v(It(arr2), It(std::end(arr2)), a);
    }
  }
#endif
  // FIXME: This is mostly the same test as above, just worse. They should be merged.
  {
    typedef std::vector<int, cpp03_allocator<int> > C;
    typedef C::allocator_type Alloc;
    Alloc a;
    {
      Alloc::construct_called = false;
      C v(arr1, arr1 + 1, a);
      assert(Alloc::construct_called);
    }
    {
      Alloc::construct_called = false;
      C v(arr2, arr2 + 3, a);
      assert(Alloc::construct_called);
    }
  }
  {
    typedef std::vector<int, cpp03_overload_allocator<int> > C;
    typedef C::allocator_type Alloc;
    Alloc a;
    {
      Alloc::construct_called = false;
      C v(arr1, arr1 + 1, a);
      assert(Alloc::construct_called);
    }
    {
      Alloc::construct_called = false;
      C v(arr2, arr2 + 3, a);
      assert(Alloc::construct_called);
    }
  }
}

TEST_CONSTEXPR_CXX20 bool test() {
  basic_tests();
  emplaceable_concept_tests(); // See PR34898

  return true;
}

int main(int, char**) {
  test();
#if TEST_STD_VER > 17
  static_assert(test());
#endif
  test_ctor_under_alloc();

  return 0;
}
