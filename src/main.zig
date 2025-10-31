const std = @import("std");
const zbf = @import("zbf");
const clap = @import("clap");
const fs = std.fs;
const io = std.io;
const BoundedArray = std.BoundedArray;
const stdout = io.getStdOut().writer();

pub fn main() !void {
    try zbf.bufferedPrint("Brainf*ck Compiler...\n");

    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();

    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\-i, --interpreter      Initializes a stdin & stdout interpreter after (if applicable) running the file.
        \\-f, --file <str>...    Path to .bf brainf*ck file that will be ran.
        \\
    );

    // Initialize our diagnostics, which can be used for reporting useful errors.
    // This is optional. You can also pass `.{}` to `clap.parse` if you don't
    // care about the extra information `Diagnostic` provides.
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = gpa.allocator(),
    }) catch |err| {
        // Report useful error and exit.
        try diag.reportToFile(.stderr(), err);
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0)
        return clap.helpToFile(.stderr(), clap.Help, &params, .{});
    for (res.args.file) |s|
        try parseFileBF(s);
    // for (res.positionals[0]) |pos|
    //     std.debug.print("{s}\n", .{pos});
}

fn parseFileBF(filename: []const u8) !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const alloc = gpa.allocator();
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();

    var line = std.Io.Writer.Allocating.init(alloc);
    defer line.deinit();
    var r_buf: [4096]u8 = undefined;
    var fr: std.fs.File.Reader = file.reader(&r_buf);
    const r = &fr.interface;

    while (true) {
        _ = r.streamDelimiter(&line.writer, '\n') catch |e| {
            if (e == error.EndOfStream) break else return e;
        };
        _ = r.toss(1);
        std.debug.print("{s}\n", .{line.written()});
        line.clearRetainingCapacity();
    }

    if (line.written().len > 0) { // remaining text beyond the last '\n'
        std.debug.print("{s}\n", .{line.written()});
    }
}
