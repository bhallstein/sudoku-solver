const std = @import("std");

test "all tests" {
    _ = @import("sudoku-solver.zig");
    std.testing.refAllDecls(@This());
}
