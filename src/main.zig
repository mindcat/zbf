const std = @import("std");
const zbf = @import("zbf");

pub fn main() !void {
    try zbf.bufferedPrint("testing buffered print...");
}
