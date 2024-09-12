# Sudoku solvers

Simple, brute-force sudoku solvers in various languages, as a language learning exercise.


## C

```sh
cd c
bash compile.sh [--run]
```


## Ruby

```sh
cd ruby
# something
```


## Zig

```sh
cd zig
zig build run [-- ../examples/eg.argv.2.txt]
```


## JS/Node

```sh
cd js
node sudoku-solver.mjs $(cat ../examples/eg.arg.1.txt)
```


## Benchmarks

Basic benchmark just for fun, 100k solves, looping over the `solve()` function.

| *C*       |       | *Ruby*     | *Zig*        |       | *JS*  |
| :-------- | :---- | :--------- | :----------- | :---- | :---- |
| clang     | 0.61s | Not tested | Debug        | 1.59s | 0.62s |
| clang -O1 | 0.44s |            | ReleaseSafe  | 0.20s |       |
| clang -O2 | 0.16s |            | ReleaseSmall | 0.42s |       |
| clang -O3 | 0.15s |            | ReleaseFast  | 0.14s |       |
| clant -Os | 0.26s |            |              |       |       |

_System:_ Mac Mini M1, clang 15.0.0, zig 13.0.0, node 20.17.0

_Notes:_
- Zig: using `Debug` performance is notably slow, `ReleaseSmall` also surprisingly so considering that `clang -Os` tends to be quite speedy. `ReleaseFast` manages to be the fastest of all -- at a guess it pips the C version due to some function param differences that could be ironed out.
- JS/Node: is shockingly performant, as well as being by far the quickest to bash out.
