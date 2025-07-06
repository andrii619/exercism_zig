const std = @import("std");

pub fn build(b: *std.Build) void {
    const target_file = b.option([]const u8, "target_file", "Name of the .zig source file to build (without .zig extension)") orelse {
        std.debug.print("Error: must pass -Dtarget_file=<name>\n", .{});
        std.process.exit(1);
    };
    // const echo = b.addExecutable(.{ .name = "echo", .root_source_file = b.path("./echo/echo.zig"), .target = target, .optimize = optimize });
    const exe = b.addExecutable(.{
        // .name = target_file,
        .name = "out",
        .root_source_file = b.path(target_file),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    b.installArtifact(exe);
}
