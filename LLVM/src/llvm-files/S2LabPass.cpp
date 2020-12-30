//===-- S2LabPass.cpp -----------------------------------------------===//
//
//===----------------------------------------------------------------------===//

#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/InitializePasses.h"

#include <cxxabi.h>
#include <set>

#define MAXLEN 10000

using namespace llvm;
using namespace std;

map<string, string> targetClassMap;
map<string, string>::iterator tIt;

namespace {
  struct S2Lab : public ModulePass {
    static char ID;
    S2Lab() : ModulePass(ID) {}

    bool runOnModule(Module &M) {
      llvm::errs() << "Hi S2Lab pass\n";
      return false;
    }
  };
}  // end anonymous namespace

//register pass
char S2Lab::ID;

INITIALIZE_PASS(S2Lab, "S2Lab", "S2LabPass: s2lab default pass", false, false)

ModulePass *llvm::createS2LabPass() {
  return new S2Lab();
}
