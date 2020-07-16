module jukeboxd.notifier.socks;

import std.stdio;
import std.socket;
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
    private string socketPath = "/tmp/socks.sock";
    private UnixAddress socketAddress;

    this() {
        this.socketAddress = new UnixAddress(this.socketPath);
    }

    public void notify(Message msg) {
        // TODO maybe try to reuse the socket?
        Socket socket = new Socket(
                AddressFamily.UNIX, 
                SocketType.STREAM
        );
        Bson bson = serializeToBson(msg);
        socket.connect(this.socketAddress);
        socket.send(bson.data);
        socket.close();
    }
}