module jukeboxd.notifier.socks;

import std.stdio;
import std.socket;
import dyaml = dyaml;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.protocol;
import jukeboxd.notifier;

/**
 * SocksNotifier sends all messages to the Socks deamon.
 * 
 * Source of the socks daemon can be found under /socks.
 * 
 * Socks publishes all messages as json over a websocket.
 */
class SocksNotifier : Notifier {
    private string socketPath;
    private UnixAddress socketAddress;

    this(dyaml.Node config) {
        this.socketPath = config["socks"]["socketPath"].as!string;
        this.socketAddress = new UnixAddress(this.socketPath);
    }

    public void notify(Message msg) {
        try {
            // TODO maybe try to reuse the socket?
            Socket socket = new Socket(
                    AddressFamily.UNIX, 
                    SocketType.STREAM
            );
            Bson bson = serializeToBson(msg);
            socket.connect(this.socketAddress);
            socket.send(bson.data);
            socket.close();
        } catch (SocketException e) {
            writeln("SocksNotifier:" ~ e.msg);
        }
    }
}