const Client = struct {
	ip: std.net.Ipv4,
	socket: std.net.socket
	nickname: [32]const u8,
	connected: bool,
	failed: bool
	state: u64 // state is necessery for sync to server
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
		self.send.sendAll(message);
	}
	
};
