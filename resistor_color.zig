const std = @import("std");

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

const colors_array = [_]ColorBand{ .black, .brown, .red, .orange, .yellow, .green, .blue, .violet, .grey, .white };

pub fn colorCode(color: ColorBand) usize {
    return @intFromEnum(color);
}

pub fn colors() []const ColorBand {
    return colors_array[0..];
}

pub fn main() !void {
    const code = colorCode(.black); // anonymous enum value inference

    try std.testing.expectEqual(code, @intFromEnum(ColorBand.black));
}
