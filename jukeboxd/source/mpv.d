import std.stdio;
import std.string;
import vibe.data.bson : Bson;
import protocol;
import modules;

// Bindings to mpv/client.h
struct  mpv_handle {}

extern (C) mpv_handle *mpv_create();
extern (C) int mpv_initialize(mpv_handle *ctx);
extern (C) int mpv_set_option_string(mpv_handle *ctx, const char *name, const char *data);
//extern (C) int mpv_command(mpv_handle *ctx, const char **args);
extern (C) int mpv_command(mpv_handle *ctx, const (char)*[]  args);

// Actual Code

mpv_handle *getMpvHandle() {
    mpv_handle *handle = mpv_create();
    mpv_set_option_string(handle, "no-video", "true");
    return handle;
}


class MpvModule : Module, MethodProvider {
    
    mpv_handle *mpv;

    this() {
        this.mpv = getMpvHandle();
        mpv_initialize(mpv);
    }

    string getName() {
        return "mpv";
    }

    void stopPlayback() {

    }

    void playUrl(const char *url) {
        const (char)*[] cmd = ["loadfile", url, null];
        mpv_command(this.mpv, cmd);
    }
   
    Method[] getMethods() {
        return [new MpvPlayMethod(this)];
    } 
}


class MpvPlayMethod : Method {
    private MpvModule mpv;
    
    this(MpvModule mpv) {
        this.mpv = mpv;
    }

    string getName() {
        return "mpv_play";
    };

    MethodResult run(Request req) {
        string url = req.params.get!string();
        
        writeln(url);

        this.mpv.playUrl(toStringz(url));
        
        return MethodResult(200, Bson("yay"));
    }
}

