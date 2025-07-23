const std = @import("std");
const debug = std.debug;
const testing = std.testing;

const triangle = @This();

pub const TriangleError = error{Invalid};

pub const Triangle = struct {
    // This struct, as well as its fields and methods, needs to be implemented.
    a: f64,
    b: f64,
    c: f64,

    pub fn init(a: f64, b: f64, c: f64) TriangleError!Triangle {
        const epsilon = std.math.floatEps(f64);
        var is_valid = (a > epsilon) and (b > epsilon) and (c > epsilon);

        is_valid = is_valid and (a + b >= c) and (b + c >= a) and (a + c >= b);
        if (!is_valid) return TriangleError.Invalid;

        return Triangle{
            .a = a,
            .b = b,
            .c = c,
        };
    }

    pub fn isEquilateral(self: Triangle) bool {
        const epsilon = std.math.floatEps(f64);

        const eq_ab = std.math.approxEqAbs(f64, self.a, self.b, epsilon);
        const eq_ac = std.math.approxEqAbs(f64, self.a, self.c, epsilon);
        // const eq_bc = std.math.approxEqAbs(f64, self.b, self.c, epsilon);

        return eq_ab and eq_ac;
    }

    pub fn isIsosceles(self: Triangle) bool {
        const epsilon = std.math.floatEps(f64);

        const eq_ab = std.math.approxEqAbs(f64, self.a, self.b, epsilon);
        const eq_ac = std.math.approxEqAbs(f64, self.a, self.c, epsilon);
        const eq_bc = std.math.approxEqAbs(f64, self.b, self.c, epsilon);

        return (eq_ab or eq_ac or eq_bc);
    }

    pub fn isScalene(self: Triangle) bool {
        const epsilon = std.math.floatEps(f64);

        const eq_ab = std.math.approxEqAbs(f64, self.a, self.b, epsilon);
        const eq_ac = std.math.approxEqAbs(f64, self.a, self.c, epsilon);
        const eq_bc = std.math.approxEqAbs(f64, self.b, self.c, epsilon);

        return !eq_ab and !eq_ac and !eq_bc;
    }
};
test "equilateral all sides are equal" {
    const actual = try triangle.Triangle.init(2, 2, 2);
    try testing.expect(actual.isEquilateral());
}
test "equilateral any side is unequal" {
    const actual = try triangle.Triangle.init(2, 3, 2);
    try testing.expect(!actual.isEquilateral());
}
test "equilateral no sides are equal" {
    const actual = try triangle.Triangle.init(5, 4, 6);
    try testing.expect(!actual.isEquilateral());
}
test "equilateral all zero sides is not a triangle" {
    const actual = triangle.Triangle.init(0, 0, 0);
    try testing.expectError(triangle.TriangleError.Invalid, actual);
}
test "equilateral sides may be floats" {
    const actual = try triangle.Triangle.init(0.5, 0.5, 0.5);
    try testing.expect(actual.isEquilateral());
}
test "isosceles last two sides are equal" {
    const actual = try triangle.Triangle.init(3, 4, 4);
    try testing.expect(actual.isIsosceles());
}
test "isosceles first two sides are equal" {
    const actual = try triangle.Triangle.init(4, 4, 3);
    try testing.expect(actual.isIsosceles());
}
test "isosceles first and last sides are equal" {
    const actual = try triangle.Triangle.init(4, 3, 4);
    try testing.expect(actual.isIsosceles());
}
test "equilateral triangles are also isosceles" {
    const actual = try triangle.Triangle.init(4, 3, 4);
    try testing.expect(actual.isIsosceles());
}
test "isosceles no sides are equal" {
    const actual = try triangle.Triangle.init(2, 3, 4);
    try testing.expect(!actual.isIsosceles());
}
test "isosceles first triangle inequality violation" {
    const actual = triangle.Triangle.init(1, 1, 3);
    try testing.expectError(triangle.TriangleError.Invalid, actual);
}
test "isosceles second triangle inequality violation" {
    const actual = triangle.Triangle.init(1, 3, 1);
    try testing.expectError(triangle.TriangleError.Invalid, actual);
}
test "isosceles third triangle inequality violation" {
    const actual = triangle.Triangle.init(3, 1, 1);
    try testing.expectError(triangle.TriangleError.Invalid, actual);
}
test "isosceles sides may be floats" {
    const actual = try triangle.Triangle.init(0.5, 0.4, 0.5);
    try testing.expect(actual.isIsosceles());
}
test "scalene no sides are equal" {
    const actual = try triangle.Triangle.init(5, 4, 6);
    try testing.expect(actual.isScalene());
}
test "scalene all sides are equal" {
    const actual = try triangle.Triangle.init(4, 4, 4);
    try testing.expect(!actual.isScalene());
}
test "scalene first and second sides are equal" {
    const actual = try triangle.Triangle.init(4, 4, 3);
    try testing.expect(!actual.isScalene());
}
test "scalene first and third sides are equal" {
    const actual = try triangle.Triangle.init(3, 4, 3);
    try testing.expect(!actual.isScalene());
}
test "scalene second and third sides are equal" {
    const actual = try triangle.Triangle.init(4, 3, 3);
    try testing.expect(!actual.isScalene());
}
test "scalene may not violate triangle inequality" {
    const actual = triangle.Triangle.init(7, 3, 2);
    try testing.expectError(triangle.TriangleError.Invalid, actual);
}
test "scalene sides may be floats" {
    const actual = try triangle.Triangle.init(0.5, 0.4, 0.6);
    try testing.expect(actual.isScalene());
}
