module jukeboxd.modules.loader;

import core.stdc.stdlib : exit;
import std.stdio;
import std.typecons : Nullable, nullable;
import dyaml = dyaml;
import jukeboxd.handler; 
import jukeboxd.player; 
import jukeboxd.modules; 
import jukeboxd.modules.mpv; 
import jukeboxd.modules.youtube; 
import jukeboxd.modules.soundcloud; 
import jukeboxd.modules.files; 

final class PlaybackModuleLoader {
    dyaml.Node config;

    this(dyaml.Node config) {
        this.config = config;
    }

    void loadModules(RequestHandler handler, Player player) {
        auto playbackModules = this.config["playbackModules"];
    
        foreach(string moduleName; playbackModules) {
            if (moduleName == "mpv") {
                handler.loadModule(new MpvModule(player));
            }
        }
    }
}

final class FeatureModuleLoader {
    dyaml.Node config;

    this(dyaml.Node config) {
        this.config = config;
    }

    void loadModules(RequestHandler handler, Player player) {
        auto featureModules = this.config["features"];
    
        foreach(string featureName; featureModules) {
            if  (featureName == "youtube") {
                Nullable!YoutubePlayback playbackModule = player.findYoutubeModule();
                if (!playbackModule.isNull()) {
                    handler.loadModule(new YoutubeModule(playbackModule.get()));
                } else {
                    writefln("no module with YoutubePlayback support configured");
                    exit(1);
                }
            }

            if  (featureName == "soundcloud") {
                Nullable!SoundcloudPlayback playbackModule = player.findSoundcloudModule();
                if (!playbackModule.isNull()) {
                    handler.loadModule(new SoundcloudModule(playbackModule.get()));
                } else {
                    writefln("no module with SoundcloudModule support configured");
                    exit(1);
                }
            }

            if (featureName == "localfiles") {
                Nullable!LocalFilePlayback playbackModule = player.findLocalFileModule();

                if (!playbackModule.isNull()) {
                    handler.loadModule(new LocalFileModule(playbackModule.get()));
                } else {
                    writefln("no module with LocalFilePlayback support configured");
                    exit(1);
                }
            }

            if (featureName == "remotefiles") {
                Nullable!RemoteFilePlayback playbackModule = player.findRemoteFileModule();

                if (!playbackModule.isNull()) {
                    handler.loadModule(new RemoteFileModule(playbackModule.get()));
                } else {
                    writefln("no module with RemoteFilePlayback support configured");
                    exit(1);
                }
            }
        }
    }
}