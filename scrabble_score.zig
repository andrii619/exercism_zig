const std = @import("std");
const testing = std.testing;

pub fn score(s: []const u8) u32 {
    var scrabble_score: u32 = 0;

    // scrabble_score += 1;

    for (s) |current| {
        var current_letter = current;
        // check if lower case
        if (current_letter >= 'a' and current_letter <= 'z') {
            current_letter -= 32; // make upper case
        }

        switch (current_letter) {
            'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' => scrabble_score += 1,
            'D', 'G' => scrabble_score += 2,
            'B', 'C', 'M', 'P' => scrabble_score += 3,
            'F', 'H', 'V', 'W', 'Y' => scrabble_score += 4,
            'K' => scrabble_score += 5,
            'J', 'X' => scrabble_score += 8,
            'Q', 'Z' => scrabble_score += 10,
            else => unreachable,
        }
    }

    return scrabble_score;
}

pub fn main() !void {
    const result = score("CabBage");

    try testing.expectEqual(14, result);
}
