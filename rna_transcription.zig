const std = @import("std");
const testing = std.testing;
const debug = std.debug;

const mem = std.mem;

pub fn toRna(allocator: mem.Allocator, dna: []const u8) mem.Allocator.Error![]const u8 {
    var result = allocator.alloc(u8, dna.len) catch |err| {
        debug.print("failed to alloc memory {any}\n", .{err});
        return err;
    };

    for (dna, 0..) |nucleotide, idx| {
        switch (nucleotide) {
            'G' => result[idx] = 'C',
            'C' => result[idx] = 'G',
            'T' => result[idx] = 'A',
            'A' => result[idx] = 'U',
            else => unreachable,
        }
    }

    return result;
}
fn testTranscription(dna: []const u8, expected: []const u8) !void {
    const rna = try toRna(testing.allocator, dna);
    defer testing.allocator.free(rna);
    try testing.expectEqualStrings(expected, rna);
}
test "empty rna sequence" {
    try testTranscription("", "");
}
test "rna complement of cytosine is guanine" {
    try testTranscription("C", "G");
}
test "rna complement of guanine is cytosine" {
    try testTranscription("G", "C");
}
test "rna complement of thymine is adenine" {
    try testTranscription("T", "A");
}
test "rna complement of adenine is uracil" {
    try testTranscription("A", "U");
}
test "rna complement" {
    try testTranscription("ACGTGGTCTTAA", "UGCACCAGAAUU");
}
pub fn main() void {}
