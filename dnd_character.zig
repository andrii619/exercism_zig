const std = @import("std");
const random = std.Random;
const debug = std.debug;
const testing = std.testing;

pub fn modifier(score: i8) i8 {
    const res = std.math.divFloor(i8, score - 10, 2) catch 0;

    return res;
}

pub fn ability() i8 {
    const current_time = std.time.microTimestamp();
    var prng = std.Random.DefaultPrng.init(@intCast(current_time));

    const rng = prng.random();
    // pointer to random number generator passed as parameter
    // Simulate 1d6 roll: range [1, 6]

    const four_die_roll = [4]i8{
        rng.intRangeAtMost(i8, 1, 6),
        rng.intRangeAtMost(i8, 1, 6),
        rng.intRangeAtMost(i8, 1, 6),
        rng.intRangeAtMost(i8, 1, 6),
    };

    var min_roll: i8 = 2 ^ 7;
    var roll_sum: i8 = 0;
    for (four_die_roll) |roll| {
        if (roll < min_roll) {
            min_roll = roll;
        }
        roll_sum += roll;
    }

    roll_sum -= min_roll;

    return roll_sum;
}

pub const Character = struct {
    strength: i8,
    dexterity: i8,
    constitution: i8,
    intelligence: i8,
    wisdom: i8,
    charisma: i8,
    hitpoints: i8,

    pub fn init() Character {
        const con = ability();

        return .{
            .strength = ability(),
            .dexterity = ability(),
            .constitution = con,
            .intelligence = ability(),
            .wisdom = ability(),
            .charisma = ability(),
            .hitpoints = 10 + modifier(con),
        };
    }
};

test "ability modifier for score 3 is -4" {
    const expected: i8 = -4;
    const actual = modifier(3);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 4 is -3" {
    const expected: i8 = -3;
    const actual = modifier(4);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 5 is -3" {
    const expected: i8 = -3;
    const actual = modifier(5);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 6 is -2" {
    const expected: i8 = -2;
    const actual = modifier(6);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 7 is -2" {
    const expected: i8 = -2;
    const actual = modifier(7);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 8 is -1" {
    const expected: i8 = -1;
    const actual = modifier(8);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 9 is -1" {
    const expected: i8 = -1;
    const actual = modifier(9);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 10 is 0" {
    const expected: i8 = 0;
    const actual = modifier(10);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 11 is 0" {
    const expected: i8 = 0;
    const actual = modifier(11);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 12 is +1" {
    const expected: i8 = 1;
    const actual = modifier(12);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 13 is +1" {
    const expected: i8 = 1;
    const actual = modifier(13);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 14 is +2" {
    const expected: i8 = 2;
    const actual = modifier(14);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 15 is +2" {
    const expected: i8 = 2;
    const actual = modifier(15);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 16 is +3" {
    const expected: i8 = 3;
    const actual = modifier(16);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 17 is +3" {
    const expected: i8 = 3;
    const actual = modifier(17);
    try testing.expectEqual(expected, actual);
}
test "ability modifier for score 18 is +4" {
    const expected: i8 = 4;
    const actual = modifier(18);
    try testing.expectEqual(expected, actual);
}
fn isValidAbilityScore(n: isize) bool {
    return n >= 3 and n <= 18;
}
test "random ability is within range" {
    for (0..20) |_| {
        const actual = ability();
        try testing.expect(isValidAbilityScore(actual));
    }
}
fn isValid(c: Character) bool {
    return isValidAbilityScore(c.strength) and
        isValidAbilityScore(c.dexterity) and
        isValidAbilityScore(c.constitution) and
        isValidAbilityScore(c.intelligence) and
        isValidAbilityScore(c.wisdom) and
        isValidAbilityScore(c.charisma) and
        (c.hitpoints == 10 + modifier(c.constitution));
}
test "random character is valid" {
    for (0..20) |_| {
        const character = Character.init();
        try testing.expect(isValid(character));
    }
}

pub fn main() void {
    const my_char = Character.init();

    debug.print("hello world,. char str:{d}\n", .{my_char.strength});
}
