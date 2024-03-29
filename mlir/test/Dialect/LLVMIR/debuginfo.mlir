// RUN: mlir-opt %s | mlir-opt | FileCheck %s

// CHECK-DAG: #[[FILE:.*]] = #llvm.di_file<"debuginfo.mlir" in "/test/">
#file = #llvm.di_file<"debuginfo.mlir" in "/test/">

// CHECK-DAG: #[[CU:.*]] = #llvm.di_compile_unit<sourceLanguage = DW_LANG_C, file = #[[FILE]], producer = "MLIR", isOptimized = true, emissionKind = Full>
#cu = #llvm.di_compile_unit<
  sourceLanguage = DW_LANG_C, file = #file, producer = "MLIR",
  isOptimized = true, emissionKind = Full
>

// CHECK-DAG: #[[INT0:.*]] = #llvm.di_basic_type<tag = DW_TAG_base_type, name = "int0">
#int0 = #llvm.di_basic_type<
  // Omit the optional sizeInBits and encoding parameters.
  tag = DW_TAG_base_type, name = "int0"
>

// CHECK-DAG: #[[INT1:.*]] = #llvm.di_basic_type<tag = DW_TAG_base_type, name = "int1", sizeInBits = 32, encoding = DW_ATE_signed>
#int1 = #llvm.di_basic_type<
  tag = DW_TAG_base_type, name = "int1",
  sizeInBits = 32, encoding = DW_ATE_signed
>

// CHECK-DAG: #[[PTR0:.*]] = #llvm.di_derived_type<tag = DW_TAG_pointer_type, baseType = #[[INT0]], sizeInBits = 0, alignInBits = 0, offsetInBits = 0>
#ptr0 = #llvm.di_derived_type<
  tag = DW_TAG_pointer_type, baseType = #int0,
  sizeInBits = 0, alignInBits = 0, offsetInBits = 0
>

// CHECK-DAG: #[[PTR1:.*]] = #llvm.di_derived_type<tag = DW_TAG_pointer_type, name = "ptr1", baseType = #[[INT0]], sizeInBits = 64, alignInBits = 32, offsetInBits = 4>
#ptr1 = #llvm.di_derived_type<
  // Specify the name parameter.
  tag = DW_TAG_pointer_type, name = "ptr1", baseType = #int0,
  sizeInBits = 64, alignInBits = 32, offsetInBits = 4
>

// CHECK-DAG: #[[COMP0:.*]] = #llvm.di_composite_type<tag = DW_TAG_array_type, name = "array0", line = 10, sizeInBits = 128, alignInBits = 32>
#comp0 = #llvm.di_composite_type<
  // Omit optional parameters.
  tag = DW_TAG_array_type, name = "array0",
  line = 10, sizeInBits = 128, alignInBits = 32
>

// CHECK-DAG: #[[COMP1:.*]] = #llvm.di_composite_type<tag = DW_TAG_array_type, name = "array1", file = #[[FILE]], line = 0, scope = #[[FILE]], baseType = #[[INT0]], sizeInBits = 0, alignInBits = 0, elements = #llvm.di_subrange<count = 4 : i64>>
#comp1 = #llvm.di_composite_type<
  tag = DW_TAG_array_type, name = "array1", file = #file,
  line = 0, scope = #file, baseType = #int0, sizeInBits = 0, alignInBits = 0,
  // Specify the subrange count.
  elements = #llvm.di_subrange<count = 4>
>

// CHECK-DAG: #[[COMP2:.*]] = #llvm.di_composite_type<tag = DW_TAG_array_type, name = "array2", file = #[[FILE]], line = 0, scope = #[[FILE]], baseType = #[[INT0]], sizeInBits = 0, alignInBits = 0, elements = #llvm.di_subrange<lowerBound = 0 : i64, upperBound = 4 : i64, stride = 1 : i64>>
#comp2 = #llvm.di_composite_type<
  tag = DW_TAG_array_type, name = "array2", file = #file,
  line = 0, scope = #file, baseType = #int0, sizeInBits = 0, alignInBits = 0,
  // Specify the subrange bounds.
  elements = #llvm.di_subrange<lowerBound = 0, upperBound = 4, stride = 1>
>

// CHECK-DAG: #[[SPTYPE0:.*]] = #llvm.di_subroutine_type<callingConvention = DW_CC_normal, argumentTypes = #[[INT0]], #[[PTR0]], #[[PTR1]], #[[COMP0:.*]], #[[COMP1:.*]], #[[COMP2:.*]]>
#spType0 = #llvm.di_subroutine_type<
  callingConvention = DW_CC_normal, argumentTypes = #int0, #ptr0, #ptr1, #comp0, #comp1, #comp2
>

// CHECK-DAG: #[[SPTYPE1:.*]] = #llvm.di_subroutine_type<resultType = #[[INT1]], argumentTypes = #[[INT1]]>
#spType1 = #llvm.di_subroutine_type<
  // Omit the optional callingConvention parameter.
  resultType = #int1, argumentTypes = #int1
>

// CHECK-DAG: #[[SP0:.*]] = #llvm.di_subprogram<compileUnit = #[[CU]], scope = #[[FILE]], name = "addr", linkageName = "addr", file = #[[FILE]], line = 3, scopeLine = 3, subprogramFlags = "Definition|Optimized", type = #[[SPTYPE0]]>
#sp0 = #llvm.di_subprogram<
  compileUnit = #cu, scope = #file, name = "addr", linkageName = "addr",
  file = #file, line = 3, scopeLine = 3, subprogramFlags = "Definition|Optimized", type = #spType0
>

// CHECK-DAG: #[[SP1:.*]] = #llvm.di_subprogram<compileUnit = #[[CU]], scope = #[[FILE]], name = "value", file = #[[FILE]], line = 4, scopeLine = 4, subprogramFlags = Definition, type = #[[SPTYPE1]]>
#sp1 = #llvm.di_subprogram<
  // Omit the optional linkageName parameter.
  compileUnit = #cu, scope = #file, name = "value",
  file = #file, line = 4, scopeLine = 4, subprogramFlags = "Definition", type = #spType1
>

// CHECK-DAG: #[[VAR0:.*]] = #llvm.di_local_variable<scope = #[[SP0]], name = "arg", file = #[[FILE]], line = 6, arg = 1, alignInBits = 0, type = #[[INT0]]>
#var0 = #llvm.di_local_variable<
  scope = #sp0, name = "arg", file = #file,
  line = 6, arg = 1, alignInBits = 0, type = #int0
>

// CHECK-DAG: #[[VAR1:.*]] = #llvm.di_local_variable<scope = #[[SP1]], name = "arg", file = #[[FILE]], line = 7, arg = 2, alignInBits = 0, type = #[[INT1]]>
#var1 = #llvm.di_local_variable<
  scope = #sp1, name = "arg", file = #file,
  line = 7, arg = 2, alignInBits = 0, type = #int1
>

// CHECK: llvm.func @addr(%[[ARG:.*]]: i64)
llvm.func @addr(%arg: i64) {
  // CHECK: %[[ALLOC:.*]] = llvm.alloca
  %allocCount = llvm.mlir.constant(1 : i32) : i32
  %alloc = llvm.alloca %allocCount x i64 : (i32) -> !llvm.ptr<i64>

  // CHECK: llvm.dbg.addr #[[VAR0]] = %[[ALLOC]]
  // CHECK: llvm.dbg.declare #[[VAR0]] = %[[ALLOC]]
  llvm.dbg.addr #var0 = %alloc : !llvm.ptr<i64>
  llvm.dbg.declare #var0 = %alloc : !llvm.ptr<i64>
  llvm.return
}

// CHECK: llvm.func @value(%[[ARG:.*]]: i32)
llvm.func @value(%arg: i32) -> i32 {
  // CHECK: llvm.dbg.value #[[VAR1]] = %[[ARG]]
  llvm.dbg.value #var1 = %arg : i32
  llvm.return %arg : i32
}
