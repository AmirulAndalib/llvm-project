//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <clc/opencl/atomic/atom_add.h>
#include <clc/opencl/atomic/atomic_add.h>

#ifdef cl_khr_global_int32_base_atomics
#define __CLC_ATOMIC_OP add
#define __CLC_ATOMIC_ADDRESS_SPACE global
#include "atom_int32_binary.inc"
#endif // cl_khr_global_int32_base_atomics

#ifdef cl_khr_local_int32_base_atomics
#define __CLC_ATOMIC_OP add
#define __CLC_ATOMIC_ADDRESS_SPACE local
#include "atom_int32_binary.inc"
#endif // cl_khr_local_int32_base_atomics

#ifdef cl_khr_int64_base_atomics

#define IMPL(AS, TYPE)                                                         \
  _CLC_OVERLOAD _CLC_DEF TYPE atom_add(volatile AS TYPE *p, TYPE val) {        \
    return __sync_fetch_and_add_8(p, val);                                     \
  }

IMPL(global, long)
IMPL(global, unsigned long)
IMPL(local, long)
IMPL(local, unsigned long)
#undef IMPL

#endif // cl_khr_int64_base_atomics
