//===- BufferizableOpInterfaceImpl.cpp - Impl. of BufferizableOpInterface -===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Vector/Transforms/BufferizableOpInterfaceImpl.h"

#include "mlir/Dialect/Bufferization/IR/BufferizableOpInterface.h"
#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Bufferization/IR/DstBufferizableOpInterfaceImpl.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/Operation.h"

using namespace mlir;
using namespace mlir::bufferization;
using namespace mlir::vector;

namespace mlir {
namespace vector {
namespace {

/// Bufferization of vector.transfer_read. Replaced with a new
/// vector.transfer_read that operates on a memref.
struct TransferReadOpInterface
    : public BufferizableOpInterface::ExternalModel<TransferReadOpInterface,
                                                    vector::TransferReadOp> {
  bool bufferizesToMemoryRead(Operation *op, OpOperand &opOperand,
                              const AnalysisState &state) const {
    assert(isa<RankedTensorType>(opOperand.get().getType()) &&
           "only tensor types expected");
    return true;
  }

  bool bufferizesToMemoryWrite(Operation *op, OpOperand &opOperand,
                               const AnalysisState &state) const {
    assert(isa<RankedTensorType>(opOperand.get().getType()) &&
           "only tensor types expected");
    return false;
  }

  AliasingValueList getAliasingValues(Operation *op, OpOperand &opOperand,
                                      const AnalysisState &state) const {
    return {};
  }

  LogicalResult bufferize(Operation *op, RewriterBase &rewriter,
                          const BufferizationOptions &options,
                          BufferizationState &state) const {
    auto readOp = cast<vector::TransferReadOp>(op);
    assert(isa<TensorType>(readOp.getShapedType()) &&
           "only tensor types expected");
    FailureOr<Value> buffer =
        getBuffer(rewriter, readOp.getBase(), options, state);
    if (failed(buffer))
      return failure();
    replaceOpWithNewBufferizedOp<vector::TransferReadOp>(
        rewriter, readOp, readOp.getVectorType(), *buffer, readOp.getIndices(),
        readOp.getPermutationMap(), readOp.getPadding(), readOp.getMask(),
        readOp.getInBoundsAttr());
    return success();
  }
};

/// Bufferization of vector.transfer_write. Replace with a new
/// vector.transfer_write that operates on a memref.
///
/// Note: DstBufferizableOpInterfaceExternalModel provides many default method
/// implementations for DestinationStyle ops.
struct TransferWriteOpInterface
    : public DstBufferizableOpInterfaceExternalModel<TransferWriteOpInterface,
                                                     vector::TransferWriteOp> {
  bool bufferizesToMemoryRead(Operation *op, OpOperand &opOperand,
                              const AnalysisState &state) const {
    auto writeOp = cast<vector::TransferWriteOp>(op);

    // Does not bufferize to a memory read if the vector completely overwrites
    // the buffer.

    // Destination must have static shape.
    if (!writeOp.getShapedType().hasStaticShape())
      return true;

    // All offsets must be 0.
    for (Value offset : writeOp.getIndices()) {
      if (getConstantIntValue(offset) != 0)
        return true;
    }

    // There is no mask.
    if (writeOp.isMasked())
      return true;

    // Must write at least the full dimension size.
    for (auto [d0, d1] : llvm::zip(writeOp.getShapedType().getShape(),
                                   writeOp.getVectorType().getShape())) {
      if (d0 > d1)
        return true;
    }

    return false;
  }

  LogicalResult bufferize(Operation *op, RewriterBase &rewriter,
                          const BufferizationOptions &options,
                          BufferizationState &state) const {
    auto writeOp = cast<vector::TransferWriteOp>(op);
    assert(isa<TensorType>(writeOp.getShapedType()) &&
           "only tensor types expected");

    // Create a new transfer_write on buffer that doesn't have a return value.
    FailureOr<Value> resultBuffer =
        getBuffer(rewriter, writeOp.getBase(), options, state);
    if (failed(resultBuffer))
      return failure();
    vector::TransferWriteOp::create(
        rewriter, writeOp.getLoc(), writeOp.getVector(), *resultBuffer,
        writeOp.getIndices(), writeOp.getPermutationMapAttr(),
        writeOp.getMask(), writeOp.getInBoundsAttr());
    replaceOpWithBufferizedValues(rewriter, op, *resultBuffer);

    return success();
  }
};

/// Bufferization of vector.gather. Replaced with a new vector.gather that
/// operates on a memref.
struct GatherOpInterface
    : public BufferizableOpInterface::ExternalModel<GatherOpInterface,
                                                    vector::GatherOp> {
  bool bufferizesToMemoryRead(Operation *op, OpOperand &opOperand,
                              const AnalysisState &state) const {
    assert(isa<RankedTensorType>(opOperand.get().getType()) &&
           "only tensor types expected");
    return true;
  }

  bool bufferizesToMemoryWrite(Operation *op, OpOperand &opOperand,
                               const AnalysisState &state) const {
    assert(isa<RankedTensorType>(opOperand.get().getType()) &&
           "only tensor types expected");
    return false;
  }

  AliasingValueList getAliasingValues(Operation *op, OpOperand &opOperand,
                                      const AnalysisState &state) const {
    return {};
  }

  LogicalResult bufferize(Operation *op, RewriterBase &rewriter,
                          const BufferizationOptions &options,
                          BufferizationState &state) const {
    auto gatherOp = cast<vector::GatherOp>(op);
    assert(isa<TensorType>(gatherOp.getBaseType()) &&
           "only tensor types expected");
    FailureOr<Value> buffer =
        getBuffer(rewriter, gatherOp.getBase(), options, state);
    if (failed(buffer))
      return failure();
    replaceOpWithNewBufferizedOp<vector::GatherOp>(
        rewriter, gatherOp, gatherOp.getVectorType(), *buffer,
        gatherOp.getIndices(), gatherOp.getIndexVec(), gatherOp.getMask(),
        gatherOp.getPassThru());
    return success();
  }
};

/// Bufferization of vector.mask. Replaced with a new vector.mask that
/// operates on a memref.
struct MaskOpInterface
    : public BufferizableOpInterface::ExternalModel<MaskOpInterface,
                                                    vector::MaskOp> {
  AliasingOpOperandList
  getAliasingOpOperands(Operation *op, Value value,
                        const AnalysisState &state) const {
    // MaskOps do not have tensor OpOperands. The yielded values are the result
    // of the wrapped op.
    auto maskOp = cast<vector::MaskOp>(op);
    size_t resultNum = std::distance(op->getOpResults().begin(),
                                     llvm::find(op->getOpResults(), value));
    auto yieldOp =
        cast<vector::YieldOp>(maskOp.getMaskRegion().front().getTerminator());
    return {{&yieldOp->getOpOperand(resultNum), BufferRelation::Equivalent}};
  }

  LogicalResult
  resolveConflicts(Operation *op, RewriterBase &rewriter,
                   const AnalysisState &analysisState,
                   const BufferizationState &bufferizationState) const {
    auto bufferizableOp = cast<BufferizableOpInterface>(op);
    if (failed(bufferizableOp.resolveTensorOpOperandConflicts(
            rewriter, analysisState, bufferizationState)))
      return failure();

    // TODO: Remove this function when vector.mask bodies can bufferize
    // out-of-place. This is currently not supported because yielding allocs
    // from a block leads to a memory leak and because vector.mask supports only
    // a single op in its body.
    auto maskOp = cast<vector::MaskOp>(op);
    if (!maskOp.getMaskRegion()
             .front()
             .getOps<bufferization::AllocTensorOp>()
             .empty())
      return op->emitOpError("body must bufferize in-place");

    return success();
  }

  LogicalResult bufferize(Operation *op, RewriterBase &rewriter,
                          const BufferizationOptions &options,
                          BufferizationState &state) const {
    auto maskOp = cast<vector::MaskOp>(op);

    // Do not bufferize if the masked op is not bufferizable.
    Operation *maskedOp = maskOp.getMaskableOp();
    if (!options.dynCastBufferizableOp(maskedOp))
      return success();

    // Update the terminator: Drop all operands that are not results of the
    // masked op.
    auto yieldOp =
        cast<vector::YieldOp>(maskOp.getMaskRegion().front().getTerminator());
    SmallVector<Value> newReturnValues(maskOp->getNumResults(), Value());
    SmallVector<Value> newYieldedValues;
    for (const auto &it : llvm::enumerate(yieldOp.getOperands())) {
      if (llvm::is_contained(maskedOp->getOpResults(), it.value())) {
        newYieldedValues.push_back(it.value());
      } else {
        // This used to be a tensor result of the masked op, but is now a memref
        // that is defined outside of the vector.mask op.
        newReturnValues[it.index()] = it.value();
      }
    }
    rewriter.modifyOpInPlace(yieldOp, [&]() {
      yieldOp.getOperandsMutable().assign(newYieldedValues);
    });

    // Create a new vector.mask op.
    ValueRange newYieldedValuesRange(newYieldedValues);
    TypeRange newResultTypes(newYieldedValuesRange);
    auto newOp = vector::MaskOp::create(
        rewriter, op->getLoc(), newResultTypes, maskOp.getMask(),
        maskOp.getPassthru(),
        /*maskableOp=*/nullptr,
        /*maskRegionBuilder=*/[](OpBuilder &b, Operation *) {});
    newOp.getRegion().takeBody(maskOp.getMaskRegion());

    // Replace all uses of the old vector.mask op.
    int idx = 0;
    for (int i = 0; i < static_cast<int>(maskOp->getNumResults()); ++i) {
      if (!newReturnValues[i])
        newReturnValues[i] = newOp->getResult(idx++);
    }
    replaceOpWithBufferizedValues(rewriter, maskOp, newReturnValues);
    return success();
  }
};

/// Bufferization of vector.yield. Replaced with a new vector.yield that
/// operates on a memref.
struct YieldOpInterface
    : public BufferizableOpInterface::ExternalModel<YieldOpInterface,
                                                    vector::YieldOp> {
  bool bufferizesToMemoryRead(Operation *op, OpOperand &opOperand,
                              const AnalysisState &state) const {
    return true;
  }

  bool bufferizesToMemoryWrite(Operation *op, OpOperand &opOperand,
                               const AnalysisState &state) const {
    return false;
  }

  AliasingValueList getAliasingValues(Operation *op, OpOperand &opOperand,
                                      const AnalysisState &state) const {
    return {{op->getParentOp()->getResult(opOperand.getOperandNumber()),
             BufferRelation::Equivalent}};
  }

  bool mustBufferizeInPlace(Operation *op, OpOperand &opOperand,
                            const AnalysisState &state) const {
    // Yield operands always bufferize inplace. Otherwise, an alloc + copy
    // may be generated inside the block. We should not return/yield allocations
    // when possible.
    return true;
  }

  LogicalResult bufferize(Operation *op, RewriterBase &rewriter,
                          const BufferizationOptions &options,
                          BufferizationState &state) const {
    auto yieldOp = cast<vector::YieldOp>(op);

    // Only supported as a vector.mask terminator.
    auto maskOp = dyn_cast<vector::MaskOp>(yieldOp->getParentOp());
    if (!maskOp)
      return yieldOp->emitError("unsupported vector::YieldOp parent");

    // Do not bufferize if the masked op is not bufferizable.
    Operation *maskedOp = &maskOp.getMaskRegion().front().front();
    if (!options.dynCastBufferizableOp(maskedOp))
      return success();

    // Create a new terminator with the same number of operands. Some of these
    // may get dropped during the bufferization of vector.mask.
    SmallVector<Value> newResults;
    for (Value value : yieldOp.getOperands()) {
      if (isa<TensorType>(value.getType())) {
        FailureOr<Value> maybeBuffer =
            getBuffer(rewriter, value, options, state);
        if (failed(maybeBuffer))
          return failure();
        newResults.push_back(*maybeBuffer);
      } else {
        newResults.push_back(value);
      }
    }

    replaceOpWithNewBufferizedOp<vector::YieldOp>(rewriter, op, newResults);
    return success();
  }
};

} // namespace
} // namespace vector
} // namespace mlir

void mlir::vector::registerBufferizableOpInterfaceExternalModels(
    DialectRegistry &registry) {
  registry.addExtension(+[](MLIRContext *ctx, vector::VectorDialect *dialect) {
    TransferReadOp::attachInterface<TransferReadOpInterface>(*ctx);
    TransferWriteOp::attachInterface<TransferWriteOpInterface>(*ctx);
    GatherOp::attachInterface<GatherOpInterface>(*ctx);
    MaskOp::attachInterface<MaskOpInterface>(*ctx);
    YieldOp::attachInterface<YieldOpInterface>(*ctx);
  });
}
