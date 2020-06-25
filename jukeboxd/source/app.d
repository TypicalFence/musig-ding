import std.stdio;
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

dyaml.Node config;
RequestHandler handler;
ModuleLoader moduleLoader;


void main() {
    config = loadConfig();
    UnixAddress addr = new UnixAddress(config["jukeboxd"]["socketPath"].as!string);
    handler = RequestHandler();
    moduleLoader = new ModuleLoader(config);

    moduleLoader.loadModules(&handler);

    Socket socket = new Socket(addr, handler);
    socket.run();
}

