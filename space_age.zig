const std = @import("std");
const debug = std.debug;
const testing = std.testing;
const expectApproxEqAbs = std.testing.expectApproxEqAbs;

pub const Planet = enum {
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    const EARTH_YEAR_SECONDS: f64 = 31_557_600;
    const ORBIT_PERIODS = [_]f64{
        0.2408467,
        0.61519726,
        1.0,
        1.8808158,
        11.862615,
        29.447498,
        84.016846,
        164.79132,
    };

    pub fn age(self: Planet, seconds: usize) f64 {
        const flt_temp = 1.234;
        _ = flt_temp;
        const index = @intFromEnum(self);
        const planet_year_seconds = EARTH_YEAR_SECONDS * ORBIT_PERIODS[index];
        const age_in_years = @as(f64, @floatFromInt(seconds)) / planet_year_seconds;
        return age_in_years;
    }
};

fn testAge(planet: Planet, seconds: usize, expected_age_in_earth_years: f64) !void {
    const tolerance = 0.01;
    const actual = planet.age(seconds);
    try expectApproxEqAbs(expected_age_in_earth_years, actual, tolerance);
}
test "age on earth" {
    try testAge(Planet.earth, 1_000_000_000, 31.69);
}
test "age on mercury" {
    try testAge(Planet.mercury, 2_134_835_688, 280.88);
}
test "age on venus" {
    try testAge(Planet.venus, 189_839_836, 9.78);
}
test "age on mars" {
    try testAge(Planet.mars, 2_129_871_239, 35.88);
}
test "age on jupiter" {
    try testAge(Planet.jupiter, 901_876_382, 2.41);
}
test "age on saturn" {
    try testAge(Planet.saturn, 2_000_000_000, 2.15);
}
test "age on uranus" {
    try testAge(Planet.uranus, 1_210_123_456, 0.46);
}
test "age on neptune" {
    try testAge(Planet.neptune, 1_821_023_456, 0.35);
}
