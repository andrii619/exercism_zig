const std = @import("std");
const testing = std.testing;

pub const ColorBand = enum(usize) {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

pub fn colorCodeSingle(color: ColorBand) usize {
    return @intFromEnum(color);
}

pub fn colorCode(colors: [2]ColorBand) usize {
    return colorCodeSingle(colors[0]) * 10 + colorCodeSingle(colors[1]);
}

pub fn main() void {
    std.debug.print("meow\n", .{});
}

test "brown and black" {
    const array = [_]ColorBand{ .brown, .black };
    const expected: usize = 10;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
test "blue and grey" {
    const array = [_]ColorBand{ .blue, .grey };
    const expected: usize = 68;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
test "yellow and violet" {
    const array = [_]ColorBand{ .yellow, .violet };
    const expected: usize = 47;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
test "white and red" {
    const array = [_]ColorBand{ .white, .red };
    const expected: usize = 92;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
test "orange and orange" {
    const array = [_]ColorBand{ .orange, .orange };
    const expected: usize = 33;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
test "black and brown, one-digit" {
    const array = [_]ColorBand{ .black, .brown };
    const expected: usize = 1;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
