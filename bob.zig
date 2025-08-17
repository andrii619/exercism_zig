const std = @import("std");
const debug = std.debug;
const testing = std.testing;

// Introduction
// Bob is a lackadaisical teenager. He likes to think that he's very cool. And he definitely doesn't get excited about things. That wouldn't be cool.

// When people talk to him, his responses are pretty limited.

// Instructions
// Your task is to determine what Bob will reply to someone when they say something to him or ask him a question.

// Bob only ever answers one of five things:

// "Sure." This is his response if you ask him a question, such as "How are you?" The convention used for questions is that it ends with a question mark.
// "Whoa, chill out!" This is his answer if you YELL AT HIM. The convention used for yelling is ALL CAPITAL LETTERS.
// "Calm down, I know what I'm doing!" This is what he says if you yell a question at him.
// "Fine. Be that way!" This is how he responds to silence. The convention used for silence is nothing, or various combinations of whitespace characters.
// "Whatever." This is what he answers to anything else.

const RequestType = enum {
    SILENCE,
    QUESTION,
    YELL,
    YELL_QUESTION,
    OTHER,
};

pub fn response(s: []const u8) []const u8 {
    // assume the request is nothing
    var request_type = RequestType.SILENCE;
    // var is_all_upper: ?bool = null;
    var uppercase_count: usize = 0;
    var lowercase_count: usize = 0;
    var whitespace_count: usize = 0;
    var ends_question = false;

    var last_non_whitespace: usize = 0;
    for (s, 0..) |current_char, idx| {
        if (!std.ascii.isWhitespace(current_char)) {
            last_non_whitespace = idx;
        }
    }

    // debug.print("INPUT:{s}\n", .{s});
    // debug.print("last non whitespace {d}\n", .{last_non_whitespace});

    if (s.len == 0 or last_non_whitespace == 0) {
        return "Fine. Be that way!";
    }

    for (s[0 .. last_non_whitespace + 1], 0..) |current_char, idx| {
        // _ = current_char;
        // request_type = .OTHER;

        if (std.ascii.isAlphanumeric(current_char)) {
            // wwww
            if (std.ascii.isAlphabetic(current_char)) {
                if (std.ascii.isUpper(current_char)) {
                    uppercase_count += 1;
                } else {
                    lowercase_count += 1;
                }
            } else {
                // count numbers as lowercase
                // lowercase_count += 1;
            }
        } else if (std.ascii.isWhitespace(current_char)) {
            //  dddd
            //
            whitespace_count += 1;
        } else {
            // must be punctuation
            //
            // lowercase_count += 1;
            if (idx == last_non_whitespace and current_char == '?') {
                ends_question = true;
            }
        }
        // std.ascii.isUpper(c: u8)
        // std.ascii.isWhitespace(c: u8)
    }

    if (whitespace_count == s.len) {
        //
        request_type = RequestType.SILENCE;
    } else if (lowercase_count == 0 and uppercase_count > 0) {
        // all upper case
        if (ends_question) {
            // yell question
            request_type = RequestType.YELL_QUESTION;
        } else {
            request_type = RequestType.YELL;
        }
    } else if (uppercase_count >= 0 and lowercase_count > 0) {
        if (ends_question) {
            request_type = RequestType.QUESTION;
        } else {
            request_type = RequestType.OTHER;
        }
    } else if (uppercase_count == 0 and lowercase_count == 0 and ends_question == true) {
        request_type = RequestType.QUESTION;
    } else {
        request_type = RequestType.OTHER;
    }

    // final switch determines the return answer
    switch (request_type) {
        .QUESTION => return "Sure.",
        .SILENCE => return "Fine. Be that way!",
        .YELL => return "Whoa, chill out!",
        .YELL_QUESTION => return "Calm down, I know what I'm doing!",
        .OTHER => return "Whatever.",
    }
}

test "stating something" {
    const expected = "Whatever.";
    const actual = response("Tom-ay-to, tom-aaaah-to.");
    try testing.expectEqualStrings(expected, actual);
}
test "shouting" {
    const expected = "Whoa, chill out!";
    const actual = response("WATCH OUT!");
    try testing.expectEqualStrings(expected, actual);
}
test "shouting gibberish" {
    const expected = "Whoa, chill out!";
    const actual = response("FCECDFCAAB");
    try testing.expectEqualStrings(expected, actual);
}
test "asking a question" {
    const expected = "Sure.";
    const actual = response("Does this cryogenic chamber make me look fat?");
    try testing.expectEqualStrings(expected, actual);
}
test "asking a numeric question" {
    const expected = "Sure.";
    const actual = response("You are, what, like 15?");
    try testing.expectEqualStrings(expected, actual);
}
test "asking gibberish" {
    const expected = "Sure.";
    const actual = response("fffbbcbeab?");
    try testing.expectEqualStrings(expected, actual);
}
test "talking forcefully" {
    const expected = "Whatever.";
    const actual = response("Hi there!");
    try testing.expectEqualStrings(expected, actual);
}
test "using acronyms in regular speech" {
    const expected = "Whatever.";
    const actual = response("It's OK if you don't want to go work for NASA.");
    try testing.expectEqualStrings(expected, actual);
}
test "forceful question" {
    const expected = "Calm down, I know what I'm doing!";
    const actual = response("WHAT'S GOING ON?");
    try testing.expectEqualStrings(expected, actual);
}
test "shouting numbers" {
    const expected = "Whoa, chill out!";
    const actual = response("1, 2, 3 GO!");
    try testing.expectEqualStrings(expected, actual);
}
test "no letters" {
    const expected = "Whatever.";
    const actual = response("1, 2, 3");
    try testing.expectEqualStrings(expected, actual);
}
test "question with no letters" {
    const expected = "Sure.";
    const actual = response("4?");
    try testing.expectEqualStrings(expected, actual);
}
test "shouting with special characters" {
    const expected = "Whoa, chill out!";
    const actual = response("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!");
    try testing.expectEqualStrings(expected, actual);
}
test "shouting with no exclamation mark" {
    const expected = "Whoa, chill out!";
    const actual = response("I HATE THE DENTIST");
    try testing.expectEqualStrings(expected, actual);
}
test "statement containing question mark" {
    const expected = "Whatever.";
    const actual = response("Ending with ? means a question.");
    try testing.expectEqualStrings(expected, actual);
}
test "non-letters with question" {
    const expected = "Sure.";
    const actual = response(":) ?");
    try testing.expectEqualStrings(expected, actual);
}
test "prattling on" {
    const expected = "Sure.";
    const actual = response("Wait! Hang on. Are you going to be OK?");
    try testing.expectEqualStrings(expected, actual);
}
test "silence" {
    const expected = "Fine. Be that way!";
    const actual = response("");
    try testing.expectEqualStrings(expected, actual);
}
test "prolonged silence" {
    const expected = "Fine. Be that way!";
    const actual = response("          ");
    try testing.expectEqualStrings(expected, actual);
}
test "alternate silence" {
    const expected = "Fine. Be that way!";
    const actual = response("\t\t\t\t\t\t\t\t\t\t");
    try testing.expectEqualStrings(expected, actual);
}
test "starting with whitespace" {
    const expected = "Whatever.";
    const actual = response("         hmmmmmmm...");
    try testing.expectEqualStrings(expected, actual);
}
test "ending with whitespace" {
    const expected = "Sure.";
    const actual = response("Okay if like my  spacebar  quite a bit?   ");
    try testing.expectEqualStrings(expected, actual);
}
test "other whitespace" {
    const expected = "Fine. Be that way!";
    const actual = response("\n\r \t");
    try testing.expectEqualStrings(expected, actual);
}
test "non-question ending with whitespace" {
    const expected = "Whatever.";
    const actual = response("This is a statement ending with whitespace      ");
    try testing.expectEqualStrings(expected, actual);
}
test "multiple line question" {
    const expected = "Sure.";
    const actual = response("\nDoes this cryogenic chamber make\n me look fat?");
    try testing.expectEqualStrings(expected, actual);
}
