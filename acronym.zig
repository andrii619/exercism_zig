const std = @import("std");
const debug = std.debug;
const testing = std.testing;
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var iter = std.mem.tokenizeAny(u8, words, " _-");

    var number_chars: usize = 0;

    while (iter.next()) |token| {
        if (token.len == 0) {
            continue;
        }

        // std.debug.print("token: `{c}`\n", .{std.ascii.toUpper(token[0])});
        number_chars += 1;
    }

    var result = try allocator.alloc(u8, number_chars);

    iter.reset();
    var i: usize = 0;
    while (iter.next()) |token| : (i += 1) {
        if (token.len == 0) {
            continue;
        }

        // std.debug.print("token: `{c}`\n", .{std.ascii.toUpper(token[0])});
        result[i] = std.ascii.toUpper(token[0]);
    }

    return result;
}

test "basic" {
    const expected = "PNG";
    const actual = try abbreviate(testing.allocator, "Portable Network Graphics");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "lowercase words" {
    const expected = "ROR";
    const actual = try abbreviate(testing.allocator, "Ruby on Rails");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "punctuation" {
    const expected = "FIFO";
    const actual = try abbreviate(testing.allocator, "First In, First Out");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "all caps word" {
    const expected = "GIMP";
    const actual = try abbreviate(testing.allocator, "GNU Image Manipulation Program");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "punctuation without whitespace" {
    const expected = "CMOS";
    const actual = try abbreviate(testing.allocator, "Complementary metal-oxide semiconductor");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "very long abbreviation" {
    const expected = "ROTFLSHTMDCOALM";
    const actual = try abbreviate(testing.allocator, "Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "consecutive delimiters" {
    const expected = "SIMUFTA";
    const actual = try abbreviate(testing.allocator, "Something - I made up from thin air");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "apostrophes" {
    const expected = "HC";
    const actual = try abbreviate(testing.allocator, "Halley's Comet");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "underscore emphasis" {
    const expected = "TRNT";
    const actual = try abbreviate(testing.allocator, "The Road _Not_ Taken");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
pub fn main() !void {
    const test_str = "Something - I made up from thin air";
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) testing.expect(false) catch @panic("TEST FAIL");
    }

    const res = try abbreviate(allocator, test_str);

    defer allocator.free(res);

    debug.print("res:{s}\n", .{res});
}
