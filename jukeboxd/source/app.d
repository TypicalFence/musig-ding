import std.stdio;
import std.socket : UnixAddress;
import socket;

void main() {
    UnixAddress addr = new UnixAddress("/tmp/jukeboxd");
    Socket socket = new Socket(addr);
    socket.run();
}
