const std = @import("std");
const print = std.debug.print;

const Root = @import("sudoku-solver.zig");
const Sudoku = Root.Sudoku;
const SudokuSolveError = Root.SudokuSolveError;
const Item = Root.Item;

pub fn getSudoku(sudoku: *Sudoku) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 82) {
        print("Wrong number of arguments. Should be 81 arguments, each 1-9 or '.' for unsolved space.", .{});
        return SudokuSolveError.WrongNumberOfArgs;
    }

    for (args[1..], 0..) |arg, index| {
        const x = index % 9;
        const y = index / 9;
        const chr = arg[0];

        const is_int = chr >= '1' and chr <= '9';
        if (!is_int and chr != '.') {
            print("Invalid arg: {s}\n", .{arg});
            return SudokuSolveError.InvalidArg;
        }

        sudoku.items[x][y] = Item{
            .value = if (is_int) chr - '0' else 0,
            .x = @as(u4, @intCast(x)),
            .y = @as(u4, @intCast(y)),
        };
        if (!is_int) {
            sudoku.unsolved[sudoku.n_unsolved] = &sudoku.items[x][y];
            sudoku.n_unsolved += 1;
        }
    }
}

pub fn printSudoku(sudoku: *Sudoku) void {
    for (0..9) |y| {
        for (0..9) |x| {
            const item = sudoku.items[x][y];
            const val = item.value + item.test_value;
            if (val > 0) print("{} ", .{val}) else print(". ", .{});
        }
        print("\n", .{});
    }
    print("\n", .{});
}
