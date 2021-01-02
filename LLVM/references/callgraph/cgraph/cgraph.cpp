#include <sstream>
#include <string>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/SetVector.h"

#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"

#include "llvm/IR/CallSite.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"

using namespace llvm;
using namespace std;

namespace {

typedef SetVector<Function*> FunctionList;
typedef SmallVector<BasicBlock*, 4> BasicBlockList;
typedef SmallVector<BasicBlockList*, 4> BasicBlockTable; 
typedef DenseMap<BasicBlock*, BasicBlockList*> BasicBlockTree; 

struct CGraphPass : public llvm::ModulePass
{
	static char ID;
	CGraphPass() : ModulePass(ID) { }
	~CGraphPass();

	DenseMap<Function*, FunctionList*> cgraph;
	DenseMap<Function*, BasicBlockTree*> cfg;
	DenseMap<Function*, BasicBlockTable*> paths;
	DenseMap<Value*, Value*> defuse;
	virtual bool runOnModule(Module &m) override;
	virtual void print(raw_ostream &out, const Module* m) const override;

	// Handles control flow graph.
	void handleCFGFunction(Function &f);
	void handleCFGBasicBlock(BasicBlock &bb);

	// Extracts control paths out of the control flow graph.
	void handlePathBasicBlock(Function *f, BasicBlock *bb, 
			BasicBlockTree *bbTree);

	// Handles main call graph analysis.
	void handleCGraphFunction(Function &f);
	void handleCGraphInstruction(Instruction &i);
	void handleCGraphCallSite(Instruction &i);

	bool isFunctionPointer(Value *v);
};


char CGraphPass::ID = 0;
static RegisterPass<CGraphPass> X("CGraphPass", "CGraph Pass",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);

}

// For an analysis pass, runOnModule should perform the actual analysis and
// compute the results. The actual output, however, is produced separately.
bool
CGraphPass::runOnModule(Module &m)
{
	// Make a control flow graph.
	for (auto &f : m) {
		handleCFGFunction(f);

		for (auto &bb : f) {
			handleCFGBasicBlock(bb);
		}
	}

	// Extract all paths out of the control flow graph.
	for (auto &fbPair : cfg)
	{
		auto *f = fbPair.first;
		auto *bbTree = fbPair.second;

		auto *bbTable = new BasicBlockTable();
		assert(bbTable && "Out of memory!");
		paths.insert(std::make_pair(f, bbTable));

		if (!f->empty())
		{
			auto &bbRoot = f->getEntryBlock();
			handlePathBasicBlock(f, &bbRoot, bbTree);
		}
	}

	// Do analysis on every path.
	for (auto &fbPair : paths)
	{
		auto *f = fbPair.first;
		auto *bbTable = fbPair.second;

		handleCGraphFunction(*f);

		for (auto &bbPath : *bbTable)
		{
			for (auto &bb : *bbPath)
			{
				for (auto &i : *bb)
				{
					handleCGraphInstruction(i);
					handleCGraphCallSite(i);
				}
			}
		}
	}
	return false;
}

void 
CGraphPass::handleCFGFunction(Function &f)
{
	auto *bbTree = new BasicBlockTree();
	assert(bbTree && "Out of memory!");
	cfg.insert(std::make_pair(&f, bbTree));
}

void 
CGraphPass::handleCFGBasicBlock(BasicBlock &bb)
{
	auto *f = bb.getParent();
	auto fbPair = cfg.find(f);
	assert((fbPair != cfg.end()) && "Function has not been added!");
	auto *bbTree = fbPair->second;

	auto *bbChildren = new BasicBlockList();
	assert(bbChildren && "Out of memory!");
	bbTree->insert(std::make_pair(&bb, bbChildren));

	for (auto &i : bb)
	{
		auto *branch = dyn_cast<BranchInst>(&i);
		if (branch)
		{
			for (auto j = 0u; j < branch->getNumSuccessors(); j++)
			{
				bbChildren->push_back(branch->getSuccessor(j));
			}
		}
	}
}

void 
CGraphPass::handlePathBasicBlock(Function *f, BasicBlock *bb, 
		BasicBlockTree *bbTree)
{
	static BasicBlockList curPath;

	if (bbTree)
	{
		curPath.push_back(bb);

		auto *bbChildren = (*bbTree)[bb];
		for (auto &bbChild : *bbChildren)
			handlePathBasicBlock(f, bbChild, bbTree);

		if (bbChildren->empty())
		{
			auto *bbPath = new BasicBlockList(curPath);
			assert(bbPath && "Out of memory!");		

			auto fbPair = paths.find(f);
			assert((fbPair != paths.end()) && "Function has not been added!");
			auto *bbTable = fbPair->second;
			assert(bbTable && "Path table has not been allocated!");

			bbTable->push_back(bbPath);
		}

		curPath.pop_back();
	}
}

void
CGraphPass::handleCGraphFunction(Function &f)
{
	auto *callees = new FunctionList();
	assert(callees && "Out of memory!");
	cgraph.insert(std::make_pair(&f, callees));
}

void
CGraphPass::handleCGraphInstruction(Instruction &i)
{
	if (isa<AllocaInst>(&i))
	{
		defuse[&i] = NULL;
	}
	else if (isa<StoreInst>(&i))
	{
		auto *store = dyn_cast<StoreInst>(&i);
		defuse[store->getPointerOperand()->stripPointerCasts()] = 
			store->getValueOperand()->stripPointerCasts();
	}
	else if (isa<LoadInst>(&i))
	{
		auto *load = dyn_cast<LoadInst>(&i);
		defuse[&i] = load->getPointerOperand();
	}
	else if (isa<BitCastInst>(&i))
	{
		defuse[&i] = i.getOperand(0);
	}
	else if (isa<GetElementPtrInst>(&i))
	{
		auto *gep = dyn_cast<GetElementPtrInst>(&i);
		defuse[&i] = gep->getPointerOperand();
	}
}

void
CGraphPass::handleCGraphCallSite(Instruction &i)
{
	CallSite cs =  CallSite(&i);

	// Check whether the instruction is actually a call
	if (!cs.getInstruction())
		return;

	// Check whether the called function is directly invoked
	auto *callee = dyn_cast<Function>(cs.getCalledValue()->stripPointerCasts());
	if (!callee)
	{
		// Indirect call
		auto *call = dyn_cast<CallInst>(&i);
		auto *value = call->getCalledValue();
		while (value && !isa<Function>(value))
		{
			value = defuse[value->stripPointerCasts()];
		}
		assert(value && "Indirect call to a non-function!");
		callee = dyn_cast<Function>(value);
	}

	// Update the call graph for the particular call
	auto *caller = dyn_cast<Function>(cs.getCaller());
	auto ccPair = cgraph.find(caller);
	assert((ccPair != cgraph.end()) && "Caller has not been added!");
	auto *callees = ccPair->second;
	callees->insert(callee);
}

bool
CGraphPass::isFunctionPointer(Value *v)
{
	if (isa<Function>(v))
		return false;

	auto *pt = dyn_cast<PointerType>(v->getType());
	if (!pt)
		return false;

	// Follow pointers repeatedly
	Type *ty = pt;
	while (isa<PointerType>(ty))
		ty = ((PointerType *)ty)->getElementType();

	if (!isa<FunctionType>(ty))
		return false;

	return true;
}

char tmp[1000];
char targetFile[1000] = "/home/jeon41/test_cs510/llvm-pass-skeleton/skeleton/test.dot"; 
int checkGraph;
int totalCnt = 0;

void write_graph(string result) {
        FILE *op = fopen(targetFile, "a");
        fprintf(op, "%s\n", result.c_str());
        fclose(op);
}

// Output for a pure analysis pass should happen in the print method.
// It is called automatically after the analysis pass has finished collecting
// its information.
void
CGraphPass::print(raw_ostream &out, const Module* m) const
{
	char tmp[1000];

	sprintf(tmp, "digraph { ");
	write_graph(tmp);

	for (auto &ccPair : cgraph)
	{
		auto *caller = ccPair.first;
		auto *callees = ccPair.second;

		std::stringstream ss;
		ss << "[" << std::string(caller->getName()) << "] : ";
		for (auto &callee : *callees) {
			ss << "[" << std::string(callee->getName()) << "], ";
			sprintf(tmp, " %s -> %s", caller->getName().str().c_str(), callee->getName().str().c_str());
			write_graph(tmp);
			}
		std::string s = ss.str();
		if (!callees->empty())
			s.erase(s.begin() + s.rfind(','), s.end());
		out << s << "\n";
	}

	sprintf(tmp, "}");
	write_graph(tmp);
}

CGraphPass::~CGraphPass()
{
	for (auto &ccPair : cgraph)
	{
		auto *callees = ccPair.second;
		if (callees)
			delete callees;
	}	

	for (auto &fbPair : paths)
	{
		auto *bbTable = fbPair.second;
		if (bbTable)
		{
			for (auto &bbPath : *bbTable)
			{
				if (bbPath)
					delete bbPath;
			}
			delete bbTable;
		}
	}

	for (auto &fbPair : cfg)
	{
		auto *bbTree = fbPair.second;
		if (bbTree)
		{
			for (auto &bbPair : *bbTree)
			{
				auto *bbChildren = bbPair.second;
				if (bbChildren)
					delete bbChildren;
			}
			delete bbTree;
		}
	}
}

