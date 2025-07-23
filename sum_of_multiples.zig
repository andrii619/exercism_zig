// Introduction
// You work for a company that makes an online, fantasy-survival game.

// When a player finishes a level, they are awarded energy points. The amount of energy awarded depends on which magical items the player found while exploring that level.

// Instructions
// Your task is to write the code that calculates the energy points that get awarded to players when they complete a level.

// The points awarded depend on two things:

// The level (a number) that the player completed.
// The base value of each magical item collected by the player during that level.
// The energy points are awarded according to the following rules:

// For each magical item, take the base value and find all the multiples of that value that are less than the level number.
// Combine the sets of numbers.
// Remove any duplicates.
// Calculate the sum of all the numbers that are left.
// Let's look at an example:

// The player completed level 20 and found two magical items with base values of 3 and 5.

// To calculate the energy points earned by the player, we need to find all the unique multiples of these base values that are less than level 20.

// Multiples of 3 less than 20: {3, 6, 9, 12, 15, 18}
// Multiples of 5 less than 20: {5, 10, 15}
// Combine the sets and remove duplicates: {3, 5, 6, 9, 10, 12, 15, 18}
// Sum the unique multiples: 3 + 5 + 6 + 9 + 10 + 12 + 15 + 18 = 78
// Therefore, the player earns 78 energy points for completing level 20 and finding the two magical items with base values of 3 and 5.
//

const std = @import("std");

const debug = std.debug;
const testing = std.testing;

const mem = std.mem;

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    var map = std.AutoHashMap(u32, u32).init(allocator);
    defer map.deinit();

    var result: u64 = 0;
    for (factors) |factor| {
        if (factor == 0) continue;
        // debug.print("current factor:{d}\n", .{factor});
        var num: u32 = 1;
        while (num * factor < limit) : (num += 1) {
            const res = num * factor;
            // check if that is already present in the hash map
            // debug.print("checking if {d} is a factor of {d}\n", .{ num, factor });
            if (!map.contains(res)) {
                // insert into map
                // debug.print("inserting {d} into map\n", .{num});
                try map.put(res, res);
                result += res;
            }
        }
    }
    return result;
}
pub fn main() !void {
    debug.print("hello\n", .{});
    // const expected: u64 = 23;
    const factors = [_]u32{ 3, 5 };
    const limit = 20;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) @panic("TEST FAIL");
    }

    const actual = try sum(allocator, &factors, limit);

    debug.print("result:{d}\n", .{actual});
}

test "no multiples within limit" {
    const expected: u64 = 0;
    const factors = [_]u32{ 3, 5 };
    const limit = 1;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "one factor has multiples within limit" {
    const expected: u64 = 3;
    const factors = [_]u32{ 3, 5 };
    const limit = 4;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "more than one multiple within limit" {
    const expected: u64 = 9;
    const factors = [_]u32{3};
    const limit = 7;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "more than one factor with multiples within limit" {
    const expected: u64 = 23;
    const factors = [_]u32{ 3, 5 };
    const limit = 10;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "each multiple is only counted once" {
    const expected: u64 = 2318;
    const factors = [_]u32{ 3, 5 };
    const limit = 100;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "a much larger limit" {
    const expected: u64 = 233_168;
    const factors = [_]u32{ 3, 5 };
    const limit = 1000;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "three factors" {
    const expected: u64 = 51;
    const factors = [_]u32{ 7, 13, 17 };
    const limit = 20;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "factors not relatively prime" {
    const expected: u64 = 30;
    const factors = [_]u32{ 4, 6 };
    const limit = 15;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "some pairs of factors relatively prime and some not" {
    const expected: u64 = 4419;
    const factors = [_]u32{ 5, 6, 8 };
    const limit = 150;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "one factor is a multiple of another" {
    const expected: u64 = 275;
    const factors = [_]u32{ 5, 25 };
    const limit = 51;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "much larger factors" {
    const expected: u64 = 2_203_160;
    const factors = [_]u32{ 43, 47 };
    const limit = 10_000;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "all numbers are multiples of 1" {
    const expected: u64 = 4_950;
    const factors = [_]u32{1};
    const limit = 100;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "no factors means an empty sum" {
    const expected: u64 = 0;
    const factors = [_]u32{};
    const limit = 10_000;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "the only multiple of 0 is 0" {
    const expected: u64 = 0;
    const factors = [_]u32{0};
    const limit = 1;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "the factor 0 does not affect the sum of multiples of other factors" {
    const expected: u64 = 3;
    const factors = [_]u32{ 3, 0 };
    const limit = 4;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "solutions using include-exclude must extend to cardinality greater than 3" {
    const expected: u64 = 39_614_537;
    const factors = [_]u32{ 2, 3, 5, 7, 11 };
    const limit = 10_000;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
test "sum is greater than maximum value of u32" {
    // Note that for a u32 `limit`, the maximum sum of multiples fits in a u64.
    const expected: u64 = 4_500_000_000;
    const factors = [_]u32{100_000_000};
    const limit = 1_000_000_000;
    const actual = try sum(testing.allocator, &factors, limit);
    try testing.expectEqual(expected, actual);
}
