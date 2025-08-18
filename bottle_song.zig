const std = @import("std");
const debug = std.debug;

pub fn recite(buffer: []u8, start_bottles: u32, take_down: u32) []const u8 {
    _ = buffer;
    _ = start_bottles;
    _ = take_down;
    @compileError("please implement the recite function");
}

const meow = "meow";

pub fn main() void {
    debug.print("hello world {d}, {d}\n", .{ 1, 2 });

    for (meow) |current| {
        debug.print("current {c}]\n", .{current});
    }
}
