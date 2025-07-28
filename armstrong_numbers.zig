// Instructions
// An Armstrong number is a number that is the sum of its own digits each raised
// to the power of the number of digits.

// For example:

// 9 is an Armstrong number, because 9 = 9^1 = 9
// 10 is not an Armstrong number, because 10 != 1^2 + 0^2 = 1
// 153 is an Armstrong number, because: 153 = 1^3 + 5^3 + 3^3 = 1 + 125 + 27 = 153
// 154 is not an Armstrong number, because: 154 != 1^3 + 5^3 + 4^3 = 1 + 125 + 64 = 190
// Write some code to determine whether a number is an Armstrong number.

const std = @import("std");
const testing = std.testing;
const debug = std.debug;

pub fn isArmstrongNumber(num: u128) bool {
    if (num == 0) return true;

    var number_digits: usize = 0;
    var tmp = num;
    while (tmp > 0) : (tmp = std.math.divTrunc(u128, tmp, 10) catch 0) {
        number_digits += 1;
    }
    // this cant happen
    if (number_digits == 0) unreachable;

    tmp = num;
    var sum_of_powers: u128 = 0;
    while (tmp > 0) : (tmp = std.math.divTrunc(u128, tmp, 10) catch 0) {
        const current_digit = tmp % 10;
        sum_of_powers += std.math.pow(u128, current_digit, number_digits);
    }
    return sum_of_powers == num;
}
test "zero is an armstrong number" {
    try testing.expect(isArmstrongNumber(0));
}
test "single-digit numbers are armstrong numbers" {
    try testing.expect(isArmstrongNumber(5));
}
test "there are no two-digit armstrong numbers" {
    try testing.expect(!isArmstrongNumber(10));
}
test "three-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(153));
}
test "three-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(100));
}
test "four-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(9_474));
}
test "four-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(9_475));
}
test "seven-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(9_926_315));
}
test "seven-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(9_926_314));
}
test "33-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(186_709_961_001_538_790_100_634_132_976_990));
}
test "38-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(99_999_999_999_999_999_999_999_999_999_999_999_999));
}
test "the largest and last armstrong number" {
    try testing.expect(isArmstrongNumber(115_132_219_018_763_992_565_095_597_973_971_522_401));
}
test "the largest 128-bit unsigned integer value is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(340_282_366_920_938_463_463_374_607_431_768_211_455));
}
