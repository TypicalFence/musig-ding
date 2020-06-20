module socket;

import std.exception;
import socket = std.socket;

class AlreadyRunningException : Exception {
    
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }

}

class Socket {
    private socket.Socket listener;
    private socket.SocketSet set;
    private bool running;

    this(socket.UnixAddress addr) {
        this.running = false;

        this.listener = new socket.Socket(
                socket.AddressFamily.UNIX, 
                socket.SocketType.STREAM
        );
        this.listener.bind(addr);
        this.listener.listen(10);

        this.set = new socket.SocketSet();
    }
    
    char[] handle_request(char[]  req) {
        return req;
    }

    void run() {
        if (this.running) {
            throw new AlreadyRunningException("already running.");
        }

        this.running = true;
       
        socket.Socket[] connectedClients;
        char[1024] buffer;

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
                        auto response = handle_request((buffer[0 .. got]));
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
