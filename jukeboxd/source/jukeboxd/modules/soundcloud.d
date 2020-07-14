module jukeboxd.modules.soundcloud;

import std.typecons : Nullable, nullable;
import std.stdio;
import std.string;
import std.conv : to;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.modules;
import jukeboxd.protocol;

final class SoundcloudModule : FeatureModule {

    SoundcloudPlayback playbackModule;

    this(SoundcloudPlayback playbackModule) {
        this.playbackModule = playbackModule;        
    }

    public string getName() {
       return "soundcloud";
    }
    
    public void playUrl(string url) {
        this.playbackModule.playSoundcloudUrl(url);
    }

    Method[] getMethods() {
        return [
            new SoundcloudPlayMethod(this),
        ];
    }
}

class SoundcloudPlayMethod : Method {
    private SoundcloudModule soundcloud;

    this(SoundcloudModule sc) {
        this.soundcloud = sc;
    }

    override string getName() {
        return "sc_play";
    }

    override MethodResult run(Request req) {
        string url = req.params.get!string();

        writeln(url);

        this.soundcloud.playUrl(url);

        return MethodResult(200, Bson("yay"));
    }
}