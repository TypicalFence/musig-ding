module jukeboxd.modules.mpv;

import core.exception;
import std.stdio;
import std.string;
import std.conv : to;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.protocol;
import jukeboxd.modules;
import jukeboxd.player;

//necessary for dynamic memory allocation
import core.stdc.stdlib;

// Bindings to mpv/client.h
// general docs: https://mpv.io/manual/stable/#embedding-into-other-programs-libmpv
struct  mpv_handle {}
struct  mpv_event {}

extern (C) mpv_handle *mpv_create();
extern (C) int mpv_initialize(mpv_handle *ctx);
extern (C) int mpv_set_option_string(mpv_handle *ctx, const(char) *name, const(char) *data);
// command list https://mpv.io/manual/stable/#list-of-input-commands
extern (C) int mpv_command(mpv_handle *ctx, const(char)**  args);
extern (C) mpv_event *mpv_wait_event(mpv_handle *ctx, double timeout);
extern (C) const(char) *mpv_error_string(int error);
// property list https://mpv.io/manual/stable/#properties
extern (C) char *mpv_get_property_string(mpv_handle *ctx, const char *name);

// Actual Code
mpv_handle *getMpvHandle() {
    mpv_handle *handle = mpv_create();
    mpv_set_option_string(handle, "vid", "no");
    return handle;
}

class MpvModule : PlaybackModule, MethodProvider,
                  YoutubePlayback, SoundcloudPlayback,
                  LocalFilePlayback, RemoteFilePlayback {

    mpv_handle *mpv;

    this() {
        this.mpv = getMpvHandle();
        mpv_initialize(mpv);
    }

    string getName() {
        return "mpv";
    }
    
    string getProperty(const(char)* name) {
        char *value = mpv_get_property_string(this.mpv, name);
        return to!string(value);
    }

    bool isPlaying() {
        string paused_str = this.getProperty("core-idle");
        if (paused_str == "yes") {
            return false;
        } 
        
        return true;
    }

    PlaybackInfo getPlaybackInfo() {
        string path = this.getProperty("path");
        string paused_str = this.getProperty("core-idle");
        string artist = this.getProperty("metadata/by-key/artist");
        string title = this.getProperty("metadata/by-key/title");
        bool playing;

        if (paused_str == "yes") {
            playing = false;
        } else {
            playing = true;
        }
        
        if (title == "") {
            string icy_title = this.getProperty("metadata/by-key/icy-title");

            try {
                string[] elements = icy_title.split(" - ");
                artist = elements[0];
                title = elements[1];
            } catch (RangeError) {
                writeln(icy_title);
            }
        }

        MediaInfo media_info = MediaInfo(artist, title);
        return PlaybackInfo(path, playing, media_info);
    }

    int stopPlayback() {
        const(char)** cmd = cast(const(char)**) malloc(2);
        cmd[0] = toStringz("stop");
        cmd[2] = null;
        int status = mpv_command(this.mpv, cmd);
        free(cmd);
        return status;
    }

    int playUrl(const(char) *url) {
        //dynamically allocate 3 bytes...
        const(char)** cmd = cast(const(char)**) malloc(3);
        
        //do the magic
        cmd[0] = toStringz("loadfile");
        cmd[1] = url;
        cmd[2] = null;
        int status = mpv_command(this.mpv, cmd);
        
        //...and delete/free them again
        free(cmd);

        return status;
    }

    void playYoutubeUrl(string url) {
        this.playUrl(toStringz(url));
    }

    void playSoundcloudUrl(string url) {
        this.playUrl(toStringz(url));
    }

    void playLocalFile(string path) {
        this.playUrl(toStringz(path));
    }

    void playRemoteFileUrl(string url) {
        this.playUrl(toStringz(url));
    }

    Method[] getMethods() {
        return [
            new MpvPlayMethod(this), 
            new MpvStopMethod(this),
            new MpvInfoMethod(this),
        ];
    }
}


class MpvPlayMethod : Method {
    private MpvModule mpv;

    this(MpvModule mpv) {
        this.mpv = mpv;
    }

    override string getName() {
        return "mpv_play";
    }

    override MethodResult run(Request req) {
        string url = req.params.get!string();

        writeln(url);

        this.mpv.playUrl(toStringz(url));

        return MethodResult(200, Bson("yay"));
    }
}


class MpvStopMethod : Method {
    private MpvModule mpv;

    this(MpvModule mpv) {
        this.mpv = mpv;
    }
    
    override string getName() {
        return "mpv_stop";
    };

    override MethodResult run(Request req) {
        int status = this.mpv.stopPlayback();

        if (status != 0) {
            auto error_msg = fromStringz(mpv_error_string(status));
            return MethodResult(500, Bson(to!string(error_msg)));
        }

        return MethodResult(200, Bson("yay"));
    }
}

class MpvInfoMethod : Method {
    private MpvModule mpv;

    this(MpvModule mpv) {
        this.mpv = mpv;
    }
    
    override string getName() {
        return "mpv_info";
    }

    override MethodResult run(Request req) {
        
        string path = this.mpv.getProperty("path");
        string paused_str = this.mpv.getProperty("core-idle");
        string artist = this.mpv.getProperty("metadata/by-key/artist");
        string title = this.mpv.getProperty("metadata/by-key/title");
        bool playing;

        if (paused_str == "yes") {
            playing = false;
        } else {
            playing = true;
        }
        
        if (title == "") {
            string icy_title = this.mpv.getProperty("metadata/by-key/icy-title");

            try {
                string[] elements = icy_title.split(" - ");
                artist = elements[0];
                title = elements[1];
            } catch (RangeError) {
                writeln(icy_title);
            }
        }

        MediaInfo media_info = MediaInfo(artist, title);
        PlaybackInfo playback_info = PlaybackInfo(path, playing, media_info);

        return MethodResult(200, serializeToBson(playback_info));
    }
}
