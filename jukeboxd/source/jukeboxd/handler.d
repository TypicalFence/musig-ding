module jukeboxd.handler;

import std.stdio;
import std.typecons : Nullable, nullable;
import std.algorithm: canFind;
import vibe.data.bson : Bson;
import jukeboxd.player;
import jukeboxd.protocol;
import jukeboxd.modules;

final class RequestHandler {
    private Player player;
    private Method[string] methods;

    this() {
        this.player = new Player();
        this.registerProvider(this.player);
    }

    public void loadModule(Module mod) {
        writefln("loading module: " ~ mod.getName());
        auto playback = cast(PlaybackModule) mod;
        auto feature = cast(FeatureModule) mod;
        auto provider = cast(MethodProvider) mod;

       //if (cast(PlaybackModule) mod) {
         //   this.playbackModules ~= cast (PlaybackModule) mod;
 

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

    public Nullable!YoutubePlayback findYoutubeModule() {
        return this.player.findYoutubeModule();
        
    }

    public Nullable!SoundcloudPlayback findSoundcloudModule() {
        return this.player.findSoundcloudModule();
    }
}
