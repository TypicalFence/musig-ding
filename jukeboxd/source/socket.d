module socket;

import std.exception;
import socket = std.socket;
import vibe.data.bson : Bson, deserializeBson, serializeToBson, fromBsonData;
import handler : RequestHandler;
import protocol;

class AlreadyRunningException : Exception {
    
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }

}

final class Socket {
    private socket.Socket listener;
    private socket.SocketSet set;
    private RequestHandler requestHandler;
    private bool running;

    this(socket.UnixAddress addr, RequestHandler handler) {
        this.running = false;

        this.listener = new socket.Socket(
                socket.AddressFamily.UNIX, 
                socket.SocketType.STREAM
        );
        this.listener.bind(addr);
        this.listener.listen(10);

        this.set = new socket.SocketSet();

        this.requestHandler = handler;
    }
    
    immutable(ubyte)[] handle_request(immutable(ubyte)[]  req) {
        Request request;
        Bson bson = Bson(Bson.Type.binData, req);
        deserializeBson!Request(request, bson);
        MethodResult result = this.requestHandler.handle_request(request);
        Bson resultBson = serializeToBson(result);
        return resultBson.data;
    }

    void run() {
        if (this.running) {
            throw new AlreadyRunningException("already running.");
        }

        this.running = true;
       
        socket.Socket[] connectedClients;
        ubyte[1024] buffer;

        while(this.running) {
            this.set.reset();
            this.set.add(listener);

            foreach(client; connectedClients){ 
                this.set.add(client);
            }

            if(socket.Socket.select(this.set, null, null)) {
                foreach(client; connectedClients) {
                    if(this.set.isSet(client)) {
                        // read from it and echo it back
                        auto got = client.receive(buffer);
                        auto response = handle_request(cast(immutable(ubyte)[]) (buffer[0 .. got]));
                        client.send(response);
                    }
                }

                if(this.set.isSet(listener)) {
                    // the listener is ready to read, that means
                    // a new client wants to connect. We accept it here.
                    auto newSocket = listener.accept();
                    connectedClients ~= newSocket; // add to our list
                }
            }
        }
    }
}
