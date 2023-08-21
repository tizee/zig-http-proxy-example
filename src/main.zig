const std = @import("std");
const Allocator = std.mem.Allocator;
const uri = std.Uri.parse("https://www.google.com") catch unreachable;
const dprint = std.debug.print;

pub fn main() !void {
    // ...
}

test "Connect google without proxy" {
    const allocator = std.testing.allocator;
    const expect = std.testing.expect;

    var client: std.http.Client = .{ .allocator = allocator };
    defer client.deinit();

    var req = client.request(.GET, uri, .{ .allocator = allocator }, .{}) catch |err| {
        try expect(err == std.http.Client.ConnectUnproxiedError.ConnectionTimedOut);
        return;
    };
    defer req.deinit();
    try req.start();
    try req.wait();

    dprint("{}\n", .{req.response.status == .ok});
}

test "Connect google with http proxy" {
    const allocator = std.testing.allocator;
    const expect = std.testing.expect;

    var client: std.http.Client = .{ .allocator = allocator, .proxy = .{ .protocol = .plain, .host = "127.0.0.1", .port = 7890 } };
    defer client.deinit();

    var req = client.request(.GET, uri, .{ .allocator = allocator }, .{}) catch |err| {
        try expect(err == std.http.Client.ConnectUnproxiedError.ConnectionTimedOut);
        return;
    };
    defer req.deinit();
    try req.start();
    try req.wait();

    dprint("{}\n", .{req.response.status == .ok});
}
