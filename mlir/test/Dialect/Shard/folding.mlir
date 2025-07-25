// RUN: mlir-opt -test-grid-simplifications %s | FileCheck %s

shard.grid @grid0(shape = 4x?x2)
shard.grid @grid1(shape = 2x3)

// CHECK-LABEL: func.func @grid_shape_op_folding
func.func @grid_shape_op_folding() -> (index, index) {
  // CHECK: %[[AXIS_2_SIZE:.*]] = arith.constant 2 : index
  // CHECK: %[[AXIS_1_SIZE:.*]] = shard.grid_shape @grid0 axes = [1] : index
  %0:2 = shard.grid_shape @grid0 axes = [2, 1] : index, index
  // CHECK: return %[[AXIS_2_SIZE]], %[[AXIS_1_SIZE]]
  return %0#0, %0#1 : index, index
}

// CHECK-LABEL: func.func @grid_shape_op_folding_all_axes_static_grid
func.func @grid_shape_op_folding_all_axes_static_grid() -> (index, index) {
  // CHECK: %[[AXIS_0_SIZE:.*]] = arith.constant 2 : index
  // CHECK: %[[AXIS_1_SIZE:.*]] = arith.constant 3 : index
  %0:2 = shard.grid_shape @grid1 : index, index
  // CHECK: return %[[AXIS_0_SIZE]], %[[AXIS_1_SIZE]]
  return %0#0, %0#1 : index, index
}
