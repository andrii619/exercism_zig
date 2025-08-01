const std = @import("std");
const debug = std.debug;
const testing = std.testing;

pub const ChessboardError = error{
    IndexOutOfBounds,
};

var chessboard_grains = [_]?u64{null} ** 65;

pub fn square(index: usize) ChessboardError!u64 {
    if (index > 64 or index == 0) return ChessboardError.IndexOutOfBounds;

    if (chessboard_grains[index]) |num_grains| {
        return num_grains;
    } else {
        // compute the number of grains for this square
        if (index == 1) {
            return 1;
        } else {
            if (chessboard_grains[index - 1]) |prev_num| {
                const res = std.math.mul(u64, 2, prev_num) catch 0;
                chessboard_grains[index] = res;
                return res;
            } else {
                // need to compute the prev index too
                const res = try square(index - 1);
                chessboard_grains[index] = 2 * res;
                return 2 * res;
            }

            // const result_prev = square(index-1);
            // if(result_prev) |result_prev_unwrap| {
            // chessboard_grains[]
            // }
            // return 2 * (try square(index - 1));
        }
    }
}

pub fn total() u64 {
    var num_grains: u64 = 0;
    for (1..65) |num_square| {
        num_grains += square(num_square) catch 0;
    }

    return num_grains;
}

const grains = @This();

test "grains on square 1" {
    const expected: u64 = 1;
    const actual = try grains.square(1);
    try testing.expectEqual(expected, actual);
}
test "grains on square 2" {
    const expected: u64 = 2;
    const actual = try grains.square(2);
    try testing.expectEqual(expected, actual);
}
test "grains on square 3" {
    const expected: u64 = 4;
    const actual = try grains.square(3);
    try testing.expectEqual(expected, actual);
}
test "grains on square 4" {
    const expected: u64 = 8;
    const actual = try grains.square(4);
    try testing.expectEqual(expected, actual);
}
test "grains on square 16" {
    const expected: u64 = 32_768;
    const actual = try grains.square(16);
    try testing.expectEqual(expected, actual);
}
test "grains on square 32" {
    const expected: u64 = 2_147_483_648;
    const actual = try grains.square(32);
    try testing.expectEqual(expected, actual);
}
test "grains on square 64" {
    const expected: u64 = 9_223_372_036_854_775_808;
    const actual = try grains.square(64);
    try testing.expectEqual(expected, actual);
}
test "square 0 produces an error" {
    const expected = ChessboardError.IndexOutOfBounds;
    const actual = grains.square(0);
    try testing.expectError(expected, actual);
}
test "square greater than 64 produces an error" {
    const expected = ChessboardError.IndexOutOfBounds;
    const actual = grains.square(65);
    try testing.expectError(expected, actual);
}
test "returns the total number of grains on the board" {
    const expected: u64 = 18_446_744_073_709_551_615;
    const actual = grains.total();
    // debug.print("got {d}\n", .{actual});
    try testing.expectEqual(expected, actual);
}
