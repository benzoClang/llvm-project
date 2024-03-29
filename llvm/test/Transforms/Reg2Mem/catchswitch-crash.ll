; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=reg2mem -S < %s | FileCheck %s

declare void @"read_mem"()

define void @"memcpy_seh"() personality i8* bitcast (i32 (...)* @__C_specific_handler to i8*) {
; CHECK-LABEL: @memcpy_seh(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %"reg2mem alloca point" = bitcast i32 0 to i32
; CHECK-NEXT:    invoke void @read_mem()
; CHECK-NEXT:    to label [[CLEANUP:%.*]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[TMP0:%.*]] = catchswitch within none [label %__except] unwind to caller
; CHECK:       __except:
; CHECK-NEXT:    [[TMP1:%.*]] = catchpad within [[TMP0]] [i8* null]
; CHECK-NEXT:    unreachable
; CHECK:       cleanup:
; CHECK-NEXT:    ret void
;
entry:
  invoke void @"read_mem"()
  to label %cleanup unwind label %catch.dispatch

catch.dispatch:                                   ; preds = %entry
  %0 = catchswitch within none [label %__except] unwind to caller

__except:                                         ; preds = %catch.dispatch
  %1 = catchpad within %0 [i8* null]
  unreachable

cleanup:                                          ; preds = %entry
  ret void
}

declare i32 @__C_specific_handler(...)
