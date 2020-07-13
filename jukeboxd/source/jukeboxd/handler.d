module jukeboxd.handler;

import std.stdio;
import std.typecons : Nullable, nullable;
import vibe.data.bson : Bson;
import jukeboxd.protocol;
import jukeboxd.modules;

struct RequestHandler {
    private PlaybackModule[] playbackModules; 
    private FeatureModule[] featureModules;
    private Method[string] methods;

    public void registerProvider(MethodProvider provider) {
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
            if (is(typeof(playbackModule) == YoutubePlayback)) {
                Nullable!YoutubePlayback result = cast(YoutubePlayback) playbackModule;

                writeln(":3");
                return result;
            }
        }
        writeln("oh no");

        return Nullable!YoutubePlayback.init;
    }
}
