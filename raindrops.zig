const std = @import("std");

// Introduction
// Raindrops is a slightly more complex version of the FizzBuzz challenge, a classic interview question.

// Instructions
// Your task is to convert a number into its corresponding raindrop sounds.

// If a given number:

// is divisible by 3, add "Pling" to the result.
// is divisible by 5, add "Plang" to the result.
// is divisible by 7, add "Plong" to the result.
// is not divisible by 3, 5, or 7, the result should be the number as a string.
// Examples
// 28 is divisible by 7, but not 3 or 5, so the result would be "Plong".
// 30 is divisible by 3 and 5, but not 7, so the result would be "PlingPlang".
// 34 is not divisible by 3, 5, or 7, so the result would be "34".
//

pub fn convert(buffer: []u8, n: u32) []const u8 {
    // _ = buffer;
    // _ = n;
    // @compileError("please implement the convert function");

    if ((n % 3 == 0) or (n % 5 == 0) or (n % 7 == 0)) {
        var required_len: u64 = 0;
        if (n % 3 == 0) required_len += 5;
        if (n % 5 == 0) required_len += 5;
        if (n % 7 == 0) required_len += 5;
        if (buffer.len < required_len) return buffer[0..0];

        var current_idx: u64 = 0;

        if (n % 3 == 0) {
            std.mem.copyForwards(u8, buffer[current_idx..], "Pling");
            current_idx += 5;
        }
        if (n % 5 == 0) {
            std.mem.copyForwards(u8, buffer[current_idx..], "Plang");
            current_idx += 5;
        }
        if (n % 7 == 0) {
            std.mem.copyForwards(u8, buffer[current_idx..], "Plong");
            current_idx += 5;
        }

        return buffer[0..current_idx];
    } else {
        // return n as a string
        //

        const str = std.fmt.bufPrint(buffer, "{d}", .{n}) catch |err| {
            std.debug.print("error: {any}", .{err});

            return buffer[0..0];
        };

        return str;
    }
}
pub fn main() !void {
    var tmp: u32 = 5;

    for (0..10) |idx| {
        tmp += 1;
        _ = idx;
    }

    var buf: [25]u8 = undefined;
    const result = convert(&buf, tmp);

    std.debug.print("meow {d}\n{s}\n", .{ tmp, result });
}
