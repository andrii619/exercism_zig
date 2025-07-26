// Instructions
// Calculate the points scored in a single toss of a Darts game.

// Darts is a game where players throw darts at a target.

// In our particular instance of the game, the target rewards 4 different amounts of points,
// depending on where the dart lands:

// Our dart scoreboard with values from a complete miss to a bullseye

// If the dart lands outside the target, player earns no points (0 points).
// If the dart lands in the outer circle of the target, player earns 1 point.
// If the dart lands in the middle circle of the target, player earns 5 points.
// If the dart lands in the inner circle of the target, player earns 10 points.
// The outer circle has a radius of 10 units
// (this is equivalent to the total radius for the entire target),
// the middle circle a radius of 5 units, and the inner circle a radius of 1.
// Of course, they are all centered at the same point — that is,
// the circles are concentric defined by the coordinates (0, 0).

// Given a point in the target (defined by its Cartesian coordinates x and y, where x and y are real), calculate the correct score earned by a dart landing at that point.

const std = @import("std");
const debug = std.debug;
const testing = std.testing;
const math = std.math;

pub const Coordinate = struct {
    // This struct, as well as its fields and methods, needs to be implemented.
    x_coord: f32 = 0,
    y_coord: f32 = 0,

    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        // _ = x_coord;
        // _ = y_coord;
        // @compileError("please implement the init method");
        //

        //
        return Coordinate{ .x_coord = x_coord, .y_coord = y_coord };
    }
    pub fn score(self: Coordinate) usize {
        // _ = self;
        // @compileError("please implement the score method");
        const radius: f32 = math.sqrt(self.x_coord * self.x_coord + self.y_coord * self.y_coord);

        const points: usize = blk: {
            if (radius <= 1.0) {
                break :blk 10;
            } else if (radius <= 5.0) {
                break :blk 5;
            } else if (radius <= 10.0) {
                break :blk 1;
            } else break :blk 0; // This is your “default” or fallback
        };
        return points;
    }
};

const darts = @This();

test "missed target" {
    const expected: usize = 0;
    const coordinate = darts.Coordinate.init(-9.0, 9.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "on the outer circle" {
    const expected: usize = 1;
    const coordinate = darts.Coordinate.init(0.0, 10.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "on the middle circle" {
    const expected: usize = 5;
    const coordinate = darts.Coordinate.init(-5.0, 0.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "on the inner circle" {
    const expected: usize = 10;
    const coordinate = darts.Coordinate.init(0.0, -1.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "exactly on center" {
    const expected: usize = 10;
    const coordinate = darts.Coordinate.init(0.0, 0.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "near the center" {
    const expected: usize = 10;
    const coordinate = darts.Coordinate.init(-0.1, -0.1);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "just within the inner circle" {
    const expected: usize = 10;
    const coordinate = darts.Coordinate.init(0.7, 0.7);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "just outside the inner circle" {
    const expected: usize = 5;
    const coordinate = darts.Coordinate.init(0.8, -0.8);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "just within the middle circle" {
    const expected: usize = 5;
    const coordinate = darts.Coordinate.init(3.5, -3.5);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "just outside the middle circle" {
    const expected: usize = 1;
    const coordinate = darts.Coordinate.init(-3.6, -3.6);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "just within the outer circle" {
    const expected: usize = 1;
    const coordinate = darts.Coordinate.init(-7.0, 7.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "just outside the outer circle" {
    const expected: usize = 0;
    const coordinate = darts.Coordinate.init(7.1, -7.1);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
test "asymmetric position between the inner and middle circles" {
    const expected: usize = 5;
    const coordinate = darts.Coordinate.init(0.5, -4.0);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}
