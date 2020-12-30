#include "llvm/Pass.h"
#include "llvm/Function.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {
  struct s2lab : public FunctionPass {
    static char ID;
    s2lab() : FunctionPass(ID) {}

    virtual bool runOnFunction(Function &F) {
      errs() << "Hello: ";
      errs().write_escaped(F.getName()) << '\n';
      return false;
    }
  };
}

char s2lab::ID = 0;
static RegisterPass<s2lab> X("s2lab", "Hello World Pass", false, false);
