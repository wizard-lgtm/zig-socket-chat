const std = @import("std");
const net = std.net;
const Client = @import("./client.zig");

const ServerConfig = struct {
    blacklist_enabled: bool,
    whitelist_enabled: bool
};

const Server = struct {
        pub const Self = @This();

        allocator: std.mem.Allocator,
        clients: std.ArrayList(Client),
        room_size: u32,
        title: [128]u8,
        blacklist: ?std.ArrayList(Client),
        whitelist: ?std.ArrayList(Client),
        config: ServerConfig,

        pub fn init(allocator: std.mem.Allocator,config: ServerConfig)!*Self{
            var self: *Self = try allocator.create(Self); 

            self.allocator = allocator;
            self.config = config;
            self.room_size = room_size;
            self.title = title;
            self.clients = std.ArrayList(Client).init(self.allocator); 

            if(config.blacklist_enabled){
                self.blacklist = std.ArrayList(Client).init(self.allocator);
            }else{
                self.blacklist = null;
            }
            if(config.whitelist_enabled){
                self.blacklist = std.ArrayList(Client).init(self.allocator);
            }else{
                self.whitelist = null;
            }
            
            return self;
        }

        pub fn check_blacklist(self: *Self, ip: net.Ip4Address) bool {
                // ignore 
                if (self.config.blacklist_enabled == false){
                        return true;
                }

                for (self.blacklist.?.items) |client| {
                        // Not implemented yet, comparing ipv4 addresses should
                        // require removing the port section so we need split 
                        const parsing = std.mem.split(u8, client.address.in, ":");
                        const iterating_ipv4 = parsing.first(); 

                        if (ip == iteraring_ipv4){
                                // busted
                               return false;
                        }
                }
                // return true then,
                return true;
        }
        fn check_whitelist(self: *Self, ip: Ipv4) bool{
                if (self.config.whitelist == false){
                        return true;
                }
                for (client in self.whitelist) {
                        if (client.ip == ip){
                                return true;
                        }
                }
                return false;
        }

        fn new_connection(self: *Self, client: *Client) bool{
                var allowed: bool = true;
                // check blacklist and whitelist

                allowed = check_whitelist() && check_blacklist();

                if(allowed) {
                        self.clients.append(client);
                        return true;
                }
                return false;
        }

        // broadcast messageslist to all clients one by one
        fn broadcast(self: *Self){
                if (self.recvlist.len == 0) return;
                for message in self.recvlist {
                        for client in self.clients {
                                client.send(message);
                        }
                        self.recvlist.pop(message);
                }

        }
};
