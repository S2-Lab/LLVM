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
#include "llvm/Transforms/Instrumentation/s2lab.h"

#include <cxxabi.h>
#include <set>
#include <map>

#define MAXLEN 10000

using namespace llvm;
using namespace std;

// map<string, string> targetClassMap;
// map<string, string>::iterator tIt;

// namespace {
//   struct S2Lab : public ModulePass {
//     static char ID;
//     S2Lab() : ModulePass(ID) {}
    
//     void addCallAfterLocal(Module &M){

//       LLVMContext& Ctx = M.getContext();
//       Type* VoidTy = Type::getVoidTy(Ctx);

//       for (Module::iterator F = M.begin(), E = M.end(); F != E; ++F) {
//         for (Function::iterator BB = F->begin(), E = F->end(); BB != E; ++BB)
//           for (BasicBlock::iterator i = BB->begin(),
//                ie = BB->end(); i != ie; ++i) {
//             if (AllocaInst *TargetAlloca = dyn_cast<AllocaInst>(i)) {
//               IRBuilder<> Builder(TargetAlloca);
//               if (FunctionCallee ObjUpdateFunction = M.getOrInsertFunction("s2lab", VoidTy))
//                 Builder.CreateCall(ObjUpdateFunction);
//             }
//           }
//       }
//     }

//     bool runOnModule(Module &M) {
//       //addCallAfterLocal(M);

//       llvm::errs() << "Hi S2Lab pass\n";
//       return false;
//     }
//   };
// }  // end anonymous namespace

// //register pass
// char S2Lab::ID;

// INITIALIZE_PASS(S2Lab, "S2Lab", "S2LabPass: s2lab default pass", false, false)

// ModulePass *llvm::createS2LabPass() {
//   return new S2Lab();
// }

PreservedAnalyses S2LabSanitizerPass::run(Module &M,
                                              ModuleAnalysisManager &MAM) {
  llvm::errs() << "Hi S2Lab pass\n";
  return PreservedAnalyses::all();
}