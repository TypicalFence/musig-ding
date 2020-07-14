import core.stdc.stdlib;
import std.stdio;
import file = std.file;
import std.socket : UnixAddress;
import vibe.data.bson : Bson;
import dyaml = dyaml;
import jukeboxd.socket;
import jukeboxd.protocol;
import jukeboxd.handler;
import jukeboxd.modules;
import jukeboxd.modules.mpv;
import jukeboxd.constants;

dyaml.Node loadConfig() {
    return dyaml.Loader.fromFile(CONFIGPATH).load();
}

int main() {
    system("figlet jukeboxd");
    writeln("=========================================");

    if (!file.exists("/etc/musig.yml")) {
        writefln("please create /etc/musig.yml");
        return 1;
    }

    dyaml.Node config = loadConfig();
    string socketPath = config["jukeboxd"]["socketPath"].as!string;
    
    if (file.exists(socketPath)) {
        file.remove(socketPath);
    }

    UnixAddress addr = new UnixAddress(socketPath);
    
    RequestHandler handler = new RequestHandler(config);
    Socket socket = new Socket(addr, handler);
    socket.run();
    return 0;
}

