const std = @import("std");
const testing = std.testing;
const debug = std.debug;

const two_fer = @This();

pub fn twoFer(buffer: []u8, name: ?[]const u8) anyerror![]u8 {
    const message: []const u8 = if (name) |n| {
        return try std.fmt.bufPrint(buffer, "One for {s}, one for me.", .{n});
    } else {
        return try std.fmt.bufPrint(buffer, "One for you, one for me.", .{});
    };
    return message;
}
const buffer_size = 100;
test "no name given" {
    var response: [buffer_size]u8 = undefined;
    const expected = "One for you, one for me.";
    const actual = try two_fer.twoFer(&response, null);
    try testing.expectEqualStrings(expected, actual);
}
test "a name given" {
    var response: [buffer_size]u8 = undefined;
    const expected = "One for Alice, one for me.";
    const actual = try two_fer.twoFer(&response, "Alice");
    try testing.expectEqualStrings(expected, actual);
}
test "another name given" {
    var response: [buffer_size]u8 = undefined;
    const expected = "One for Bob, one for me.";
    const actual = try two_fer.twoFer(&response, "Bob");
    try testing.expectEqualStrings(expected, actual);
}
