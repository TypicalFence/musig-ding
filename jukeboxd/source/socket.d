module socket;

import core.exception;
import std.stdio;
import std.algorithm;
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
        Response response = Response("", Type.RESPONSE);
        MethodResult result;

        try {
            Request request;
            Bson bson = Bson(Bson.Type.object, req);
            deserializeBson!Request(request, bson);
            response.id = request.id;
            result = this.requestHandler.handle_request(request);
        } catch(RangeError) {
            result = MethodResult(400, Bson("invalid Resquest"));
        }
        
        response.code = result.code; 
        response.result = result.data; 
        Bson responseBson = serializeToBson(response);
        return responseBson.data;
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
                for (size_t i = 0; i < connectedClients.length; i++) {
                    std.socket.Socket client = connectedClients[i];
                    
                    if(this.set.isSet(client)) {
                        // read from it and echo it back
                        auto got = client.receive(buffer);
                        auto stuff = cast(immutable(ubyte)[]) (buffer[0 .. got]);
                        auto response = handle_request(stuff);
                        client.send(response);
                    }

                   // release socket resources now
                    client.close();
                    connectedClients = connectedClients.remove(i);
                    i--;
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
