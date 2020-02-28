//===- Version.cpp - Clang Version Number -----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines several version-related utility functions for Clang.
//
//===----------------------------------------------------------------------===//

#include "clang/Basic/Version.h"
#include "clang/Basic/LLVM.h"
#include "clang/Config/config.h"
#include "llvm/Support/raw_ostream.h"
#include <cstdlib>
#include <cstring>

namespace clang {

std::string getClangRepositoryPath() {
#if defined(CLANG_REPOSITORY_STRING)
  return CLANG_REPOSITORY_STRING;
#else
#ifdef CLANG_REPOSITORY
  return CLANG_REPOSITORY;
#else
  return "";
#endif
#endif
}

std::string getLLVMRepositoryPath() {
#if defined(CLANG_REPOSITORY_STRING)
  return CLANG_REPOSITORY_STRING;
#else
#ifdef LLVM_REPOSITORY
  return LLVM_REPOSITORY;
#else
  return "";
#endif
#endif
}

std::string getClangRevision() {
#if defined(TOOLCHAIN_REVISION_STRING)
  return TOOLCHAIN_REVISION_STRING;
#else
#ifdef CLANG_REVISION
  return CLANG_REVISION;
#else
  return "";
#endif
#endif
}

std::string getLLVMRevision() {
#if defined(TOOLCHAIN_REVISION_STRING)
  return TOOLCHAIN_REVISION_STRING;
#else
#ifdef LLVM_REVISION
  return LLVM_REVISION;
#else
  return "";
#endif
#endif
}

std::string getClangFullRepositoryVersion() {
  std::string buf;
  llvm::raw_string_ostream OS(buf);
#if defined(CLANG_TC_DATE)
  std::string Revision = CLANG_TC_DATE;
#else
  std::string Revision = "nodate";
#endif
  OS << Revision;
  return OS.str();
}

std::string getClangFullVersion() {
  return getClangToolFullVersion("clang");
}

std::string getClangToolFullVersion(StringRef ToolName) {
  std::string buf;
  llvm::raw_string_ostream OS(buf);
#ifdef CLANG_VENDOR
  OS << CLANG_VENDOR;
#endif
  OS << ToolName << " version " CLANG_VERSION_STRING
     "-" TOOLCHAIN_REVISION_STRING "("
     << getClangFullRepositoryVersion() << ")";
  return OS.str();
}

std::string getClangFullCPPVersion() {
  // The version string we report in __VERSION__ is just a compacted version of
  // the one we report on the command line.
  std::string buf;
  llvm::raw_string_ostream OS(buf);
#ifdef CLANG_VENDOR
  OS << CLANG_VENDOR;
#endif
  OS << "Clang " CLANG_VERSION_STRING " " << getClangFullRepositoryVersion();
  return OS.str();
}

} // end namespace clang
