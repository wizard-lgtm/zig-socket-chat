const std = @import("std");
const net = std.net;
const Client = @import("./client.zig");

const Server = struct {
        clients: []Client,
        room_size: u32,
        title: [128]u8,
        blacklist: ?[]Client,
        whitelist: ?[]Client,
        config: Config,

        // declare self 
        const self = @This();


        fn check_blacklist(self: *Self, ip: Ipv4) bool{
                if (self.config.blacklist == false){
                        return true;
                }
                for client in self.blacklist {
                        if (client.ip == ip){
                                return false;
                        }
                }
                return true;
        }
        fn check_whitelist(self: *Self, ip: Ipv4) bool{
                if (self.config.whitelist == false){
                        return true;
                }
                for client in self.whitelist {
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
