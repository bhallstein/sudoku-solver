const std = @import("std");

pub fn build(b: *std.Build) !void {
    const exe = b.addExecutable(.{
        .name = "sudoku-solver",
        .root_source_file = b.path("src/sudoku-solver.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    b.installArtifact(exe);

    const tests = b.addTest(.{
        .name = "sudoku-solver-tests",
        .root_source_file = b.path("src/tests.zig"),
    });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run sudoku solver");
    run_step.dependOn(&run_exe.step);

    const args_file_path = if (b.args) |args| args[0] else "../examples/eg.argv.1.txt";
    const argv = [_][]const u8{ "cat", args_file_path };
    const result = try std.process.Child.run(.{
        .argv = &argv,
        .allocator = b.allocator,
    });
    var items = std.mem.split(u8, result.stdout, " ");
    while (items.next()) |arg| {
        run_exe.addArg(arg);
    }
}
