module jukeboxd.handler;

import std.stdio;
import std.typecons : Nullable, nullable;
import std.algorithm: canFind;
import vibe.data.bson : Bson;
import jukeboxd.protocol;
import jukeboxd.modules;

struct RequestHandler {
    // TODO maybe move the modules in a dedicated player/manager class
    private PlaybackModule[] playbackModules; 
    private FeatureModule[] featureModules;
    private Method[string] methods;

    public void loadModule(Module mod) {
        writefln("loading module: " ~ mod.getName());
        auto playback = cast(PlaybackModule) mod;
        auto feature = cast(FeatureModule) mod;
        auto provider = cast(MethodProvider) mod;

       //if (cast(PlaybackModule) mod) {
         //   this.playbackModules ~= cast (PlaybackModule) mod;
 

        if (playback !is null) {
            this.playbackModules ~= playback;
        }

        if (feature !is null) {
            this.featureModules ~= feature;
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
        foreach (PlaybackModule playbackModule; this.playbackModules) {
            if (cast(YoutubePlayback) playbackModule !is null) {
                Nullable!YoutubePlayback result = cast(YoutubePlayback) playbackModule;
                return result;
            }
        }

        return Nullable!YoutubePlayback.init;
    }

    public Nullable!SoundcloudPlayback findSoundcloudModule() {
        foreach (PlaybackModule playbackModule; this.playbackModules) {
            if (cast(SoundcloudPlayback) playbackModule !is null) {
                Nullable!SoundcloudPlayback result = cast(SoundcloudPlayback) playbackModule;
                return result;
            }
        }

        return Nullable!SoundcloudPlayback.init;
    }
}
