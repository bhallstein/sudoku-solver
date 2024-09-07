const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const IO = @import("io.zig");

pub const SudokuSolveError = error{
    WrongNumberOfArgs,
    InvalidArg,
    CannotSolve,
};

pub const Sudoku = struct {
    items: [9][9]Item = undefined,
    unsolved: [81]*Item = undefined,
    n_unsolved: u8 = 0,
};

pub const Item = struct {
    value: u8 = 0,
    test_value: u8 = 0,
    x: u4,
    y: u4,
};

pub fn main() !void {
    var sudoku = Sudoku{};

    try IO.getSudoku(&sudoku);
    IO.printSudoku(&sudoku);

    const solved = solve(&sudoku, 0);
    if (!solved) {
        return SudokuSolveError.CannotSolve;
    }

    print("Sudoku solved!\n", .{});
    IO.printSudoku(&sudoku);
}

fn isConsistent(sudoku: *Sudoku, test_value: u8, at_x: u8, at_y: u8) bool {
    // Check row
    var count: u8 = 0;
    for (0..9) |x| {
        const item = sudoku.items[x][at_y];
        if (item.value + item.test_value == test_value) {
            count += 1;
            if (count > 1) {
                return false;
            }
        }
    }

    // Check column
    count = 0;
    for (0..9) |y| {
        const item = sudoku.items[at_x][y];
        if (item.value + item.test_value == test_value) {
            count += 1;
            if (count > 1) {
                return false;
            }
        }
    }

    // Check sector
    count = 0;
    const sector_x: u8 = at_x / 3 * 3;
    const sector_y: u8 = at_y / 3 * 3;
    for (0..3) |y| {
        for (0..3) |x| {
            const item = sudoku.items[x + sector_x][y + sector_y];
            if (item.value + item.test_value == test_value) {
                count += 1;
                if (count > 1) {
                    return false;
                }
            }
        }
    }

    return true;
}

fn solve(sudoku: *Sudoku, i_unsolved: u8) bool {
    for (1..10) |test_value| {
        var item = sudoku.unsolved[i_unsolved];
        item.test_value = @as(u8, @intCast(test_value));

        if (isConsistent(sudoku, item.test_value, item.x, item.y)) {
            if (i_unsolved == sudoku.n_unsolved - 1) {
                return true;
            }

            const solved = solve(sudoku, i_unsolved + 1);
            if (solved) {
                return true;
            }
        }
        item.test_value = 0;
    }
    return false;
}

test "main" {
    try std.testing.expect(true);
}
