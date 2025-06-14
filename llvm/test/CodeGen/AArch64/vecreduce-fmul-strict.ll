; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-SD,CHECK-SD-NOFP16
; RUN: llc -mtriple=aarch64 -mattr=+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-SD,CHECK-SD-FP16
; RUN: llc -mtriple=aarch64 -global-isel -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-GI,CHECK-GI-NOFP16
; RUN: llc -mtriple=aarch64 -mattr=+fullfp16 -global-isel -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-GI,CHECK-GI-FP16

define float @mul_HalfS(<2 x float> %bin.rdx)  {
; CHECK-LABEL: mul_HalfS:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    fmul s0, s0, v0.s[1]
; CHECK-NEXT:    ret
  %r = call float @llvm.vector.reduce.fmul.f32.v2f32(float 1.0, <2 x float> %bin.rdx)
  ret float %r
}

define half @mul_HalfH(<4 x half> %bin.rdx)  {
; CHECK-SD-NOFP16-LABEL: mul_HalfH:
; CHECK-SD-NOFP16:       // %bb.0:
; CHECK-SD-NOFP16-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-SD-NOFP16-NEXT:    mov h1, v0.h[1]
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h0
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s2, s1
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[2]
; CHECK-SD-NOFP16-NEXT:    mov h0, v0.h[3]
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s0, s1, s0
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    ret
;
; CHECK-SD-FP16-LABEL: mul_HalfH:
; CHECK-SD-FP16:       // %bb.0:
; CHECK-SD-FP16-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-SD-FP16-NEXT:    fmul h1, h0, v0.h[1]
; CHECK-SD-FP16-NEXT:    fmul h1, h1, v0.h[2]
; CHECK-SD-FP16-NEXT:    fmul h0, h1, v0.h[3]
; CHECK-SD-FP16-NEXT:    ret
;
; CHECK-GI-NOFP16-LABEL: mul_HalfH:
; CHECK-GI-NOFP16:       // %bb.0:
; CHECK-GI-NOFP16-NEXT:    mov w8, #15360 // =0x3c00
; CHECK-GI-NOFP16-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h0
; CHECK-GI-NOFP16-NEXT:    fmov s1, w8
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[1]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[2]
; CHECK-GI-NOFP16-NEXT:    mov h0, v0.h[3]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s0, s1, s0
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    ret
;
; CHECK-GI-FP16-LABEL: mul_HalfH:
; CHECK-GI-FP16:       // %bb.0:
; CHECK-GI-FP16-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-GI-FP16-NEXT:    fmul h1, h0, v0.h[1]
; CHECK-GI-FP16-NEXT:    fmul h1, h1, v0.h[2]
; CHECK-GI-FP16-NEXT:    fmul h0, h1, v0.h[3]
; CHECK-GI-FP16-NEXT:    ret
  %r = call half @llvm.vector.reduce.fmul.f16.v4f16(half 1.0, <4 x half> %bin.rdx)
  ret half %r
}


define half @mul_H(<8 x half> %bin.rdx)  {
; CHECK-SD-NOFP16-LABEL: mul_H:
; CHECK-SD-NOFP16:       // %bb.0:
; CHECK-SD-NOFP16-NEXT:    mov h1, v0.h[1]
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h0
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s2, s1
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[2]
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[3]
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[4]
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[5]
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[6]
; CHECK-SD-NOFP16-NEXT:    mov h0, v0.h[7]
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-SD-NOFP16-NEXT:    fcvt h1, s1
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fmul s0, s1, s0
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    ret
;
; CHECK-SD-FP16-LABEL: mul_H:
; CHECK-SD-FP16:       // %bb.0:
; CHECK-SD-FP16-NEXT:    fmul h1, h0, v0.h[1]
; CHECK-SD-FP16-NEXT:    fmul h1, h1, v0.h[2]
; CHECK-SD-FP16-NEXT:    fmul h1, h1, v0.h[3]
; CHECK-SD-FP16-NEXT:    fmul h1, h1, v0.h[4]
; CHECK-SD-FP16-NEXT:    fmul h1, h1, v0.h[5]
; CHECK-SD-FP16-NEXT:    fmul h1, h1, v0.h[6]
; CHECK-SD-FP16-NEXT:    fmul h0, h1, v0.h[7]
; CHECK-SD-FP16-NEXT:    ret
;
; CHECK-GI-NOFP16-LABEL: mul_H:
; CHECK-GI-NOFP16:       // %bb.0:
; CHECK-GI-NOFP16-NEXT:    mov w8, #15360 // =0x3c00
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h0
; CHECK-GI-NOFP16-NEXT:    fmov s1, w8
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[1]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[2]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[3]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[4]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[5]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v0.h[6]
; CHECK-GI-NOFP16-NEXT:    mov h0, v0.h[7]
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s1, s1, s2
; CHECK-GI-NOFP16-NEXT:    fcvt h1, s1
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fmul s0, s1, s0
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    ret
;
; CHECK-GI-FP16-LABEL: mul_H:
; CHECK-GI-FP16:       // %bb.0:
; CHECK-GI-FP16-NEXT:    fmul h1, h0, v0.h[1]
; CHECK-GI-FP16-NEXT:    fmul h1, h1, v0.h[2]
; CHECK-GI-FP16-NEXT:    fmul h1, h1, v0.h[3]
; CHECK-GI-FP16-NEXT:    fmul h1, h1, v0.h[4]
; CHECK-GI-FP16-NEXT:    fmul h1, h1, v0.h[5]
; CHECK-GI-FP16-NEXT:    fmul h1, h1, v0.h[6]
; CHECK-GI-FP16-NEXT:    fmul h0, h1, v0.h[7]
; CHECK-GI-FP16-NEXT:    ret
  %r = call half @llvm.vector.reduce.fmul.f16.v8f16(half 1.0, <8 x half> %bin.rdx)
  ret half %r
}

define float @mul_S(<4 x float> %bin.rdx)  {
; CHECK-LABEL: mul_S:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmul s1, s0, v0.s[1]
; CHECK-NEXT:    fmul s1, s1, v0.s[2]
; CHECK-NEXT:    fmul s0, s1, v0.s[3]
; CHECK-NEXT:    ret
  %r = call float @llvm.vector.reduce.fmul.f32.v4f32(float 1.0, <4 x float> %bin.rdx)
  ret float %r
}

define double @mul_D(<2 x double> %bin.rdx)  {
; CHECK-LABEL: mul_D:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmul d0, d0, v0.d[1]
; CHECK-NEXT:    ret
  %r = call double @llvm.vector.reduce.fmul.f64.v2f64(double 1.0, <2 x double> %bin.rdx)
  ret double %r
}

define half @mul_2H(<16 x half> %bin.rdx)  {
; CHECK-SD-NOFP16-LABEL: mul_2H:
; CHECK-SD-NOFP16:       // %bb.0:
; CHECK-SD-NOFP16-NEXT:    mov h2, v0.h[1]
; CHECK-SD-NOFP16-NEXT:    fcvt s3, h0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s2, s3, s2
; CHECK-SD-NOFP16-NEXT:    mov h3, v0.h[2]
; CHECK-SD-NOFP16-NEXT:    fcvt h2, s2
; CHECK-SD-NOFP16-NEXT:    fcvt s3, h3
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-SD-NOFP16-NEXT:    mov h3, v0.h[3]
; CHECK-SD-NOFP16-NEXT:    fcvt h2, s2
; CHECK-SD-NOFP16-NEXT:    fcvt s3, h3
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-SD-NOFP16-NEXT:    mov h3, v0.h[4]
; CHECK-SD-NOFP16-NEXT:    fcvt h2, s2
; CHECK-SD-NOFP16-NEXT:    fcvt s3, h3
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-SD-NOFP16-NEXT:    mov h3, v0.h[5]
; CHECK-SD-NOFP16-NEXT:    fcvt h2, s2
; CHECK-SD-NOFP16-NEXT:    fcvt s3, h3
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-SD-NOFP16-NEXT:    mov h3, v0.h[6]
; CHECK-SD-NOFP16-NEXT:    mov h0, v0.h[7]
; CHECK-SD-NOFP16-NEXT:    fcvt h2, s2
; CHECK-SD-NOFP16-NEXT:    fcvt s3, h3
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-SD-NOFP16-NEXT:    fcvt h2, s2
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fmul s0, s2, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h1
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v1.h[1]
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v1.h[2]
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v1.h[3]
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v1.h[4]
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v1.h[5]
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    mov h2, v1.h[6]
; CHECK-SD-NOFP16-NEXT:    mov h1, v1.h[7]
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s2, h2
; CHECK-SD-NOFP16-NEXT:    fcvt s1, h1
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    fcvt s0, h0
; CHECK-SD-NOFP16-NEXT:    fmul s0, s0, s1
; CHECK-SD-NOFP16-NEXT:    fcvt h0, s0
; CHECK-SD-NOFP16-NEXT:    ret
;
; CHECK-SD-FP16-LABEL: mul_2H:
; CHECK-SD-FP16:       // %bb.0:
; CHECK-SD-FP16-NEXT:    fmul h2, h0, v0.h[1]
; CHECK-SD-FP16-NEXT:    fmul h2, h2, v0.h[2]
; CHECK-SD-FP16-NEXT:    fmul h2, h2, v0.h[3]
; CHECK-SD-FP16-NEXT:    fmul h2, h2, v0.h[4]
; CHECK-SD-FP16-NEXT:    fmul h2, h2, v0.h[5]
; CHECK-SD-FP16-NEXT:    fmul h2, h2, v0.h[6]
; CHECK-SD-FP16-NEXT:    fmul h0, h2, v0.h[7]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, h1
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[1]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[2]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[3]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[4]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[5]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[6]
; CHECK-SD-FP16-NEXT:    fmul h0, h0, v1.h[7]
; CHECK-SD-FP16-NEXT:    ret
;
; CHECK-GI-NOFP16-LABEL: mul_2H:
; CHECK-GI-NOFP16:       // %bb.0:
; CHECK-GI-NOFP16-NEXT:    mov w8, #15360 // =0x3c00
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h0
; CHECK-GI-NOFP16-NEXT:    fmov s2, w8
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    mov h3, v0.h[1]
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h3
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    mov h3, v0.h[2]
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h3
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    mov h3, v0.h[3]
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h3
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    mov h3, v0.h[4]
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h3
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    mov h3, v0.h[5]
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h3
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    mov h3, v0.h[6]
; CHECK-GI-NOFP16-NEXT:    mov h0, v0.h[7]
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s3, h3
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s2, s2, s3
; CHECK-GI-NOFP16-NEXT:    fcvt h2, s2
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fmul s0, s2, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h1
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v1.h[1]
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v1.h[2]
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v1.h[3]
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v1.h[4]
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v1.h[5]
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    mov h2, v1.h[6]
; CHECK-GI-NOFP16-NEXT:    mov h1, v1.h[7]
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s2, h2
; CHECK-GI-NOFP16-NEXT:    fcvt s1, h1
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s2
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    fcvt s0, h0
; CHECK-GI-NOFP16-NEXT:    fmul s0, s0, s1
; CHECK-GI-NOFP16-NEXT:    fcvt h0, s0
; CHECK-GI-NOFP16-NEXT:    ret
;
; CHECK-GI-FP16-LABEL: mul_2H:
; CHECK-GI-FP16:       // %bb.0:
; CHECK-GI-FP16-NEXT:    fmul h2, h0, v0.h[1]
; CHECK-GI-FP16-NEXT:    fmul h2, h2, v0.h[2]
; CHECK-GI-FP16-NEXT:    fmul h2, h2, v0.h[3]
; CHECK-GI-FP16-NEXT:    fmul h2, h2, v0.h[4]
; CHECK-GI-FP16-NEXT:    fmul h2, h2, v0.h[5]
; CHECK-GI-FP16-NEXT:    fmul h2, h2, v0.h[6]
; CHECK-GI-FP16-NEXT:    fmul h0, h2, v0.h[7]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, h1
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[1]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[2]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[3]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[4]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[5]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[6]
; CHECK-GI-FP16-NEXT:    fmul h0, h0, v1.h[7]
; CHECK-GI-FP16-NEXT:    ret
  %r = call half @llvm.vector.reduce.fmul.f16.v16f16(half 1.0, <16 x half> %bin.rdx)
  ret half %r
}

define float @mul_2S(<8 x float> %bin.rdx)  {
; CHECK-LABEL: mul_2S:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmul s2, s0, v0.s[1]
; CHECK-NEXT:    fmul s2, s2, v0.s[2]
; CHECK-NEXT:    fmul s0, s2, v0.s[3]
; CHECK-NEXT:    fmul s0, s0, s1
; CHECK-NEXT:    fmul s0, s0, v1.s[1]
; CHECK-NEXT:    fmul s0, s0, v1.s[2]
; CHECK-NEXT:    fmul s0, s0, v1.s[3]
; CHECK-NEXT:    ret
  %r = call float @llvm.vector.reduce.fmul.f32.v8f32(float 1.0, <8 x float> %bin.rdx)
  ret float %r
}

define double @mul_2D(<4 x double> %bin.rdx)  {
; CHECK-LABEL: mul_2D:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmul d0, d0, v0.d[1]
; CHECK-NEXT:    fmul d0, d0, d1
; CHECK-NEXT:    fmul d0, d0, v1.d[1]
; CHECK-NEXT:    ret
  %r = call double @llvm.vector.reduce.fmul.f64.v4f64(double 1.0, <4 x double> %bin.rdx)
  ret double %r
}

; Added at least one test where the start value is not 1.0.
define float @mul_S_init_42(<4 x float> %bin.rdx)  {
; CHECK-LABEL: mul_S_init_42:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #1109917696 // =0x42280000
; CHECK-NEXT:    fmov s1, w8
; CHECK-NEXT:    fmul s1, s1, s0
; CHECK-NEXT:    fmul s1, s1, v0.s[1]
; CHECK-NEXT:    fmul s1, s1, v0.s[2]
; CHECK-NEXT:    fmul s0, s1, v0.s[3]
; CHECK-NEXT:    ret
  %r = call float @llvm.vector.reduce.fmul.f32.v4f32(float 42.0, <4 x float> %bin.rdx)
  ret float %r
}

; Function Attrs: nounwind readnone
declare half @llvm.vector.reduce.fmul.f16.v4f16(half, <4 x half>)
declare half @llvm.vector.reduce.fmul.f16.v8f16(half, <8 x half>)
declare half @llvm.vector.reduce.fmul.f16.v16f16(half, <16 x half>)
declare float @llvm.vector.reduce.fmul.f32.v2f32(float, <2 x float>)
declare float @llvm.vector.reduce.fmul.f32.v4f32(float, <4 x float>)
declare float @llvm.vector.reduce.fmul.f32.v8f32(float, <8 x float>)
declare double @llvm.vector.reduce.fmul.f64.v2f64(double, <2 x double>)
declare double @llvm.vector.reduce.fmul.f64.v4f64(double, <4 x double>)
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK-GI: {{.*}}
; CHECK-SD: {{.*}}
