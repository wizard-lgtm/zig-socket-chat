const std = @import("std");

const net = std.net;

const PORT: u16 = 4025;
// IPv4 adress
const addr: net.Address = net.Address.initIp4(.{ 127, 0, 0, 1 }, PORT);

// empty options (default)
const opt = net.Address.ListenOptions{
    .reuse_address = true,
    .reuse_port = true,
};
const MAX_NICKNAME_SIZE: u8 = 32;

pub fn main() !void {

    // defining the allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var server: net.Server = try addr.listen(opt);

    std.debug.print("server is listening\n", .{});
    const buffer = try allocator.alloc(u8, 1024);

    defer _ = allocator.free(buffer);
    while (true) {
        const connection: net.Server.Connection = try server.accept();

        std.debug.print("new connection! .{any}\n", .{connection.address.in});
        const readed = try connection.stream.read(buffer);

        std.debug.print("new message:{s}\n", .{buffer[0..readed]});
    }
}
