import std.stdio;
import std.socket : UnixAddress;
import vibe.data.bson : Bson;
import socket;
import protocol;
import handler;
import mpv;

class PingMethod : Method {
    string getName() {
        return "ping";
    };

    MethodResult run(Request req) {
        return MethodResult(200, Bson("Pong"));
    }
}

class MyFeatureProvider : MethodProvider {
    Method[] getMethods() {
        return [new PingMethod()];
    }
}

void main() {
    UnixAddress addr = new UnixAddress("/tmp/jukeboxd");
    RequestHandler handler = RequestHandler(); 
    handler.registerProvider(new MyFeatureProvider());
    handler.registerProvider(new MpvModule());
    Socket socket = new Socket(addr, handler);
    socket.run();
}

