const std = @import("std");
const net = std.net;

const Client = struct {
	address: std.net.Address,
	stream: std.net.Stream,
	nickname: [32]const u8,
	connected: bool,
	failed: bool,
	state: u64, // state is necessery for sync to server
	fn init(){}
	fn deinit(){}
	fn connect(self: *Self){
		self.send(self.nickname);
		const buffer = self.allocator.alloc(u8, 2);
		self.readAll(buffer);
		if(buffer == "OK"){
			self.connected = true;
		}else{
			self.failed = true;
		}
	}
	fn disconnect(){}
	fn send(self: *Self, message: []const u8){
		// sends message
		_ = try self.stream.write(message);
	}
	
};
