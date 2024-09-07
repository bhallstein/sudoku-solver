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


## Benchmarks

Very basic benchmark of 100k solves, just for fun, looping over the `solve()` function.


| *C*       |       | *Ruby*     | *Zig*        |       |
| :-------- | ----- | :--------- | :----------- | ----- |
| clang     | 0.61s | Not tested | Debug        | 1.59s |
| clang -O1 | 0.44s |            | ReleaseSafe  | 0.20s |
| clang -O2 | 0.16s |            | ReleaseSmall | 0.42s |
| clang -O3 | 0.15s |            | ReleaseFast  | 0.14s |
