module jukeboxd.handler;

import std.stdio;
import std.typecons : Nullable, nullable;
import std.algorithm: canFind;
import vibe.data.bson : Bson;
import dyaml = dyaml;
import jukeboxd.player;
import jukeboxd.protocol;
import jukeboxd.modules;
import jukeboxd.modules.loader : PlaybackModuleLoader, FeatureModuleLoader;

final class RequestHandler {
    private Player player;
    private Method[string] methods;

    this(dyaml.Node config) {
        this.player = new Player();
        this.registerProvider(this.player);
        PlaybackModuleLoader moduleLoader = new PlaybackModuleLoader(config);
        FeatureModuleLoader featureLoader = new FeatureModuleLoader(config);
        moduleLoader.loadModules(this);
        featureLoader.loadModules(this, this.player);
    }

    public void loadModule(Module mod) {
        writefln("loading module: " ~ mod.getName());
        auto playback = cast(PlaybackModule) mod;
        auto feature = cast(FeatureModule) mod;
        auto provider = cast(MethodProvider) mod;

        if (playback !is null) {
            this.player.addPlaybackModule(playback);
        }

        if (feature !is null) {
            this.player.addFeatureModule(feature);
        }

        this.registerProvider(provider);
    }

    private void registerProvider(MethodProvider provider) {
        foreach(method; provider.getMethods()) {
            writeln("loading method: " ~ method.getName());
            this.methods[method.getName()] = method;
        }
    }

    public MethodResult handle_request(Request req) {
        Method method = this.methods.get(req.method, null);
        
        if (method !is null) {
            return method.run(req);
        }

        return MethodResult(404, Bson(null));
    }
}
