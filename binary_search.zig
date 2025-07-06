const std = @import("std");
const testing = std.testing;

// Take a look at the tests, you might have to change the function arguments

pub fn binarySearch(comptime T: type, target: T, items: []const T) ?usize {
    if (items.len == 0) {
        return null;
    }

    var left_idx: usize = 0;
    var right_idx: usize = items.len - 1;

    while (left_idx <= right_idx) {
        const middle_idx = left_idx + ((right_idx - left_idx) / 2);

        const middle_element = items[middle_idx];

        if (middle_element == target) {
            return middle_idx;
        } else if (target < middle_element) {
            if (middle_idx == 0) break; // avoid underflow when middle_idx==0
            right_idx = middle_idx - 1;
        } else {
            left_idx = middle_idx + 1;
        }
    }

    return null;
}

test "finds a value in an array with one element" {
    const expected: ?usize = 0;
    const array = [_]i4{6};
    const actual = binarySearch(i4, 6, &array);
    try testing.expectEqual(expected, actual);
}
test "finds a value in the middle of an array" {
    const expected: ?usize = 3;
    const array = [_]u4{ 1, 3, 4, 6, 8, 9, 11 };
    const actual = binarySearch(u4, 6, &array);
    try testing.expectEqual(expected, actual);
}
test "finds a value at the beginning of an array" {
    const expected: ?usize = 0;
    const array = [_]i8{ 1, 3, 4, 6, 8, 9, 11 };
    const actual = binarySearch(i8, 1, &array);
    try testing.expectEqual(expected, actual);
}
test "finds a value at the end of an array" {
    const expected: ?usize = 6;
    const array = [_]u8{ 1, 3, 4, 6, 8, 9, 11 };
    const actual = binarySearch(u8, 11, &array);
    try testing.expectEqual(expected, actual);
}

test "finds a value in an array of odd length" {
    const expected: ?usize = 5;
    const array = [_]i16{ 1, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 634 };
    const actual = binarySearch(i16, 21, &array);
    try testing.expectEqual(expected, actual);
}

test "finds a value in an array of even length" {
    const expected: ?usize = 5;
    const array = [_]u16{ 1, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377 };
    const actual = binarySearch(u16, 21, &array);
    try testing.expectEqual(expected, actual);
}

// test "identifies that a value is not included in the array" {
//     const expected: ?usize = null;
//     const array = [_]i32{ 1, 3, 4, 6, 8, 9, 11 };
//     const actual = binarySearch(i32, 7, &array);
//     try testing.expectEqual(expected, actual);
// }

pub fn main() !void {
    const expected: u8 = 0;
    const array = [_]u8{ 1, 3, 4, 6, 8, 9, 11 };

    const actual = binarySearch(u8, 1, &array);

    try testing.expectEqual(expected, actual);
}
