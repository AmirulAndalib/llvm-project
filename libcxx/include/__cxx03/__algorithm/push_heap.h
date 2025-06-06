//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___CXX03___ALGORITHM_PUSH_HEAP_H
#define _LIBCPP___CXX03___ALGORITHM_PUSH_HEAP_H

#include <__cxx03/__algorithm/comp.h>
#include <__cxx03/__algorithm/comp_ref_type.h>
#include <__cxx03/__algorithm/iterator_operations.h>
#include <__cxx03/__config>
#include <__cxx03/__iterator/iterator_traits.h>
#include <__cxx03/__type_traits/is_assignable.h>
#include <__cxx03/__type_traits/is_constructible.h>
#include <__cxx03/__utility/move.h>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#  pragma GCC system_header
#endif

_LIBCPP_PUSH_MACROS
#include <__cxx03/__undef_macros>

_LIBCPP_BEGIN_NAMESPACE_STD

template <class _AlgPolicy, class _Compare, class _RandomAccessIterator>
_LIBCPP_HIDE_FROM_ABI void
__sift_up(_RandomAccessIterator __first,
          _RandomAccessIterator __last,
          _Compare&& __comp,
          typename iterator_traits<_RandomAccessIterator>::difference_type __len) {
  using value_type = typename iterator_traits<_RandomAccessIterator>::value_type;

  if (__len > 1) {
    __len                       = (__len - 2) / 2;
    _RandomAccessIterator __ptr = __first + __len;

    if (__comp(*__ptr, *--__last)) {
      value_type __t(_IterOps<_AlgPolicy>::__iter_move(__last));
      do {
        *__last = _IterOps<_AlgPolicy>::__iter_move(__ptr);
        __last  = __ptr;
        if (__len == 0)
          break;
        __len = (__len - 1) / 2;
        __ptr = __first + __len;
      } while (__comp(*__ptr, __t));

      *__last = std::move(__t);
    }
  }
}

template <class _AlgPolicy, class _RandomAccessIterator, class _Compare>
inline _LIBCPP_HIDE_FROM_ABI void
__push_heap(_RandomAccessIterator __first, _RandomAccessIterator __last, _Compare& __comp) {
  typename iterator_traits<_RandomAccessIterator>::difference_type __len = __last - __first;
  std::__sift_up<_AlgPolicy, __comp_ref_type<_Compare> >(std::move(__first), std::move(__last), __comp, __len);
}

template <class _RandomAccessIterator, class _Compare>
inline _LIBCPP_HIDE_FROM_ABI void
push_heap(_RandomAccessIterator __first, _RandomAccessIterator __last, _Compare __comp) {
  static_assert(std::is_copy_constructible<_RandomAccessIterator>::value, "Iterators must be copy constructible.");
  static_assert(std::is_copy_assignable<_RandomAccessIterator>::value, "Iterators must be copy assignable.");

  std::__push_heap<_ClassicAlgPolicy>(std::move(__first), std::move(__last), __comp);
}

template <class _RandomAccessIterator>
inline _LIBCPP_HIDE_FROM_ABI void push_heap(_RandomAccessIterator __first, _RandomAccessIterator __last) {
  std::push_heap(std::move(__first), std::move(__last), __less<>());
}

_LIBCPP_END_NAMESPACE_STD

_LIBCPP_POP_MACROS

#endif // _LIBCPP___CXX03___ALGORITHM_PUSH_HEAP_H
