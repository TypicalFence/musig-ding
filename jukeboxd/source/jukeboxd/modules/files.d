module jukeboxd.modules.files;

import std.typecons : Nullable, nullable;
import std.stdio;
import std.string;
import std.conv : to;
import vibe.data.bson : Bson;
import jukeboxd.modules;
import jukeboxd.protocol;

final class LocalFileModule : FeatureModule {

    LocalFilePlayback playbackModule;

    this(LocalFilePlayback playbackModule) {
        this.playbackModule = playbackModule;
    }

    public string getName() {
        return "localfile";
    }

    public void playLocalFile(string path) {
        this.playbackModule.playLocalFile(path);
    }

    public Method[] getMethods() {
        return [
            new LocalPlayFileMethod(this),
        ];
    } 
}

class LocalPlayFileMethod : Method {
    private LocalFileModule localFileModule;

    this(LocalFileModule mod) {
        this.localFileModule = mod;
    }

    override string getName() {
        return "localfile_play";
    }

    override MethodResult run(Request req) {
        string path = req.params.get!string();

        writeln(path);

        this.localFileModule.playLocalFile(path);

        return MethodResult(200, Bson("yay"));
    }
}

final class RemoteFileModule : FeatureModule {

    RemoteFilePlayback playbackModule;

    this(RemoteFilePlayback playbackModule) {
        this.playbackModule = playbackModule;
    }

    public string getName() {
        return "remotefile";
    }

    public void playRemoteFile(string url) {
        this.playbackModule.playRemoteFileUrl(url);
    }

    public Method[] getMethods() {
        return [
            new RemoteFilePlayMethod(this),
        ];
    } 
}

class RemoteFilePlayMethod : Method {
    private RemoteFileModule remoteFileModule;

    this(RemoteFileModule mod) {
        this.remoteFileModule = mod;
    }

    override string getName() {
        return "remotefile_play";
    }

    override MethodResult run(Request req) {
        string url = req.params.get!string();

        writeln(url);

        this.remoteFileModule.playRemoteFile(url);

        return MethodResult(200, Bson("yay"));
    }
}