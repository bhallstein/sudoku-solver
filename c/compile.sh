set -e

clang sudoku-solver.c
# A previous note said -fno-stack-protector flag required, not sure why, perhaps cgi specific

if [[ "$*" =~ "--run" ]]; then
  time ./a.out $(cat ../examples/eg.argv.1.txt)
fi
