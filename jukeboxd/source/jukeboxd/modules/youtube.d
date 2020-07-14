module jukeboxd.modules.youtube;

import std.typecons : Nullable, nullable;
import std.stdio;
import std.string;
import std.conv : to;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.modules;
import jukeboxd.protocol;

final class YoutubeModule : FeatureModule {

    YoutubePlayback playbackModule;

    this(YoutubePlayback playbackModule) {
        this.playbackModule = playbackModule;        
    }

    public string getName() {
       return "youtube";
    }
    
    public void playVideoUrl(string url) {
        this.playbackModule.playYoutubeUrl(url);
    }

    Method[] getMethods() {
        return [
            new YoutubePlayMethod(this),
        ];
    }
}

class YoutubePlayMethod : Method {
    private YoutubeModule youtube;

    this(YoutubeModule yt) {
        this.youtube = yt;
    }

    override string getName() {
        return "yt_play";
    }

    override MethodResult run(Request req) {
        string url = req.params.get!string();

        writeln(url);

        this.youtube.playVideoUrl(url);

        return MethodResult(200, Bson("yay"));
    }
}