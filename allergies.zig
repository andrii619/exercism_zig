const std = @import("std");
const EnumSet = std.EnumSet;

const debug = std.debug;
const testing = std.testing;

// zig will use a u3 to store the enum values
// it chooses the smallest width integer
pub const Allergen = enum {
    eggs,
    peanuts,
    shellfish,
    strawberries,
    tomatoes,
    chocolate,
    pollen,
    cats,
};

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    const shift: u3 = @intCast(@intFromEnum(allergen));
    return (score & (@as(u8, 1) << shift)) != 0;
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var set = EnumSet(Allergen).initEmpty();

    // std.meta.fields return an array of enum fields that is
    // comptime (only known and valid during compile time)
    // so this means that a runtime for loop wont work here.
    // We can't iterate comptime data using a runtime for. And
    // we can't use a comptime block here either since we are using a
    // runtime score variable. So we unroll the loop using inline for
    // the code becomes something like this:
    //     const allergen = Allergen.eggs;
    // const bit = @intCast(usize, 0);
    // if ((score >> bit) & 1 != 0) {
    //     set.insert(allergen);
    // }

    // const allergen = Allergen.peanuts;
    // const bit = @intCast(usize, 1);
    // if ((score >> bit) & 1 != 0) {
    //     set.insert(allergen);
    // }
    // each loop iteration is expended at compile time
    // but evaluiated at runtime
    inline for (std.meta.fields(Allergen)) |info| {
        const allergen = info.value;
        const bit: usize = @intCast(allergen);

        if ((score >> bit) & 1 != 0) {
            set.insert(@enumFromInt(allergen));
        }
    }

    return set;
}

pub fn initAllergenSet2(score: usize) EnumSet(Allergen) {
    var allergens = EnumSet(Allergen).initFull();
    var allergenIter = allergens.iterator();
    while (allergenIter.next()) |allergen| {
        const isAllergic = isAllergicTo(score, allergen);
        allergens.setPresent(allergen, isAllergic);
    }
    return allergens;
}

pub fn initAllergenSet3(score: u9) EnumSet(Allergen) {
    var allergen_set: EnumSet(Allergen) = .{};
    inline for (@typeInfo(Allergen).Enum.fields) |field|
        if (isAllergicTo(score, @enumFromInt(field.value)))
            allergen_set.insert(@enumFromInt(field.value));
    return allergen_set;
}

pub fn initAllergenSet4(score: usize) EnumSet(Allergen) {
    var allergenSet = EnumSet(Allergen).initEmpty();
    allergenSet.bits.mask = @truncate(score);
    return allergenSet;
}

test "eggs: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .eggs));
}
test "eggs: allergic only to eggs" {
    try testing.expect(isAllergicTo(1, .eggs));
}
test "eggs: allergic to eggs and something else" {
    try testing.expect(isAllergicTo(3, .eggs));
}
test "eggs: allergic to something, but not eggs" {
    try testing.expect(!isAllergicTo(2, .eggs));
}
test "eggs: allergic to everything" {
    try testing.expect(isAllergicTo(255, .eggs));
}
test "peanuts: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .peanuts));
}
test "peanuts: allergic only to peanuts" {
    try testing.expect(isAllergicTo(2, .peanuts));
}
test "peanuts: allergic to peanuts and something else" {
    try testing.expect(isAllergicTo(7, .peanuts));
}
test "peanuts: allergic to something, but not peanuts" {
    try testing.expect(!isAllergicTo(5, .peanuts));
}
test "peanuts: allergic to everything" {
    try testing.expect(isAllergicTo(255, .peanuts));
}
test "shellfish: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .shellfish));
}
test "shellfish: allergic only to shellfish" {
    try testing.expect(isAllergicTo(4, .shellfish));
}
test "shellfish: allergic to shellfish and something else" {
    try testing.expect(isAllergicTo(14, .shellfish));
}
test "shellfish: allergic to something, but not shellfish" {
    try testing.expect(!isAllergicTo(10, .shellfish));
}
test "shellfish: allergic to everything" {
    try testing.expect(isAllergicTo(255, .shellfish));
}
test "strawberries: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .strawberries));
}
test "strawberries: allergic only to strawberries" {
    try testing.expect(isAllergicTo(8, .strawberries));
}
test "strawberries: allergic to strawberries and something else" {
    try testing.expect(isAllergicTo(28, .strawberries));
}
test "strawberries: allergic to something, but not strawberries" {
    try testing.expect(!isAllergicTo(20, .strawberries));
}
test "strawberries: allergic to everything" {
    try testing.expect(isAllergicTo(255, .strawberries));
}
test "tomatoes: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .tomatoes));
}
test "tomatoes: allergic only to tomatoes" {
    try testing.expect(isAllergicTo(16, .tomatoes));
}
test "tomatoes: allergic to tomatoes and something else" {
    try testing.expect(isAllergicTo(56, .tomatoes));
}
test "tomatoes: allergic to something, but not tomatoes" {
    try testing.expect(!isAllergicTo(40, .tomatoes));
}
test "tomatoes: allergic to everything" {
    try testing.expect(isAllergicTo(255, .tomatoes));
}
test "chocolate: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .chocolate));
}
test "chocolate: allergic only to chocolate" {
    try testing.expect(isAllergicTo(32, .chocolate));
}
test "chocolate: allergic to chocolate and something else" {
    try testing.expect(isAllergicTo(112, .chocolate));
}
test "chocolate: allergic to something, but not chocolate" {
    try testing.expect(!isAllergicTo(80, .chocolate));
}
test "chocolate: allergic to everything" {
    try testing.expect(isAllergicTo(255, .chocolate));
}
test "pollen: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .pollen));
}
test "pollen: allergic only to pollen" {
    try testing.expect(isAllergicTo(64, .pollen));
}
test "pollen: allergic to pollen and something else" {
    try testing.expect(isAllergicTo(224, .pollen));
}
test "pollen: allergic to something, but not pollen" {
    try testing.expect(!isAllergicTo(160, .pollen));
}
test "pollen: allergic to everything" {
    try testing.expect(isAllergicTo(255, .pollen));
}
test "cats: not allergic to anything" {
    try testing.expect(!isAllergicTo(0, .cats));
}
test "cats: allergic only to cats" {
    try testing.expect(isAllergicTo(128, .cats));
}
test "cats: allergic to cats and something else" {
    try testing.expect(isAllergicTo(192, .cats));
}
test "cats: allergic to something, but not cats" {
    try testing.expect(!isAllergicTo(64, .cats));
}
test "cats: allergic to everything" {
    try testing.expect(isAllergicTo(255, .cats));
}
test "initAllergenSet: no allergies" {
    const expected_count: usize = 0;
    const actual = initAllergenSet(0);
    try testing.expectEqual(expected_count, actual.count());
}
test "initAllergenSet: just eggs" {
    const expected_count: usize = 1;
    const actual = initAllergenSet(1);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.eggs));
}
test "initAllergenSet: just peanuts" {
    const expected_count: usize = 1;
    const actual = initAllergenSet(2);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.peanuts));
}
test "initAllergenSet: just strawberries" {
    const expected_count: usize = 1;
    const actual = initAllergenSet(8);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.strawberries));
}
test "initAllergenSet: eggs and peanuts" {
    const expected_count: usize = 2;
    const actual = initAllergenSet(3);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.eggs));
    try testing.expect(actual.contains(.peanuts));
}
test "initAllergenSet: more than eggs but not peanuts" {
    const expected_count: usize = 2;
    const actual = initAllergenSet(5);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.eggs));
    try testing.expect(actual.contains(.shellfish));
}
test "initAllergenSet: lots of stuff" {
    const expected_count: usize = 5;
    const actual = initAllergenSet(248);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.strawberries));
    try testing.expect(actual.contains(.tomatoes));
    try testing.expect(actual.contains(.chocolate));
    try testing.expect(actual.contains(.pollen));
    try testing.expect(actual.contains(.cats));
}
test "initAllergenSet: everything" {
    const expected_count: usize = 8;
    const actual = initAllergenSet(255);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.eggs));
    try testing.expect(actual.contains(.peanuts));
    try testing.expect(actual.contains(.shellfish));
    try testing.expect(actual.contains(.strawberries));
    try testing.expect(actual.contains(.tomatoes));
    try testing.expect(actual.contains(.chocolate));
    try testing.expect(actual.contains(.pollen));
    try testing.expect(actual.contains(.cats));
}
test "initAllergenSet: no allergen score parts" {
    const expected_count: usize = 7;
    const actual = initAllergenSet(509);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.eggs));
    try testing.expect(actual.contains(.shellfish));
    try testing.expect(actual.contains(.strawberries));
    try testing.expect(actual.contains(.tomatoes));
    try testing.expect(actual.contains(.chocolate));
    try testing.expect(actual.contains(.pollen));
    try testing.expect(actual.contains(.cats));
}
test "initAllergenSet: no allergen score parts without highest valid score" {
    const expected_count: usize = 1;
    const actual = initAllergenSet(257);
    try testing.expectEqual(expected_count, actual.count());
    try testing.expect(actual.contains(.eggs));
}

pub fn main() void {
    std.debug.print("typeof(@intFromEnum(E.a)): {}\n", .{@TypeOf(@intFromEnum(Allergen.cats))});
}
