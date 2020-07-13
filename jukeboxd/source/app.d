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

dyaml.Node config;
RequestHandler handler;
PlaybackModuleLoader moduleLoader;
FeatureModuleLoader featureLoader;


int main() {
    system("figlet jukeboxd");
    writeln("=========================================");

    if (!file.exists("/etc/musig.yml")) {
        writefln("please create /etc/musig.yml");
        return 1;
    }

    config = loadConfig();
    string socketPath = config["jukeboxd"]["socketPath"].as!string;
    
    if (file.exists(socketPath)) {
        file.remove(socketPath);
    }

    UnixAddress addr = new UnixAddress(socketPath);
    handler = RequestHandler();
    moduleLoader = new PlaybackModuleLoader(config);
    featureLoader = new FeatureModuleLoader(config);

    moduleLoader.loadModules(&handler);
    featureLoader.loadModules(&handler);

    Socket socket = new Socket(addr, handler);
    socket.run();
    return 0;
}

