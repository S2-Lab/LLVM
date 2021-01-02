CLANG="/usr/bin/clang"
DOT="callgraph.dot"
PNG="callgraph.png"

$CLANG -S -emit-llvm $SOURCE -o - | opt -analyze -std-link-opts -dot-callgraph
cat $DOT | c++filt |
sed 's,>,\\>,g; s,-\\>,->,g; s,<,\\<,g' |
gawk '/external node/{id=$1} $1 != id' |
dot -Tpng -o $PNG $DOT
~                             

