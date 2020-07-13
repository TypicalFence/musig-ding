module jukeboxd.modules.loader;

import std.stdio;
import std.typecons : Nullable, nullable;
import dyaml = dyaml;
import jukeboxd.handler; 
import jukeboxd.modules; 
import jukeboxd.modules.mpv; 
import jukeboxd.modules.youtube; 
import jukeboxd.modules.soundcloud; 

final class PlaybackModuleLoader {
    dyaml.Node config;

    this(dyaml.Node config) {
        this.config = config;
    }

    void loadModules(RequestHandler *handler) {
        auto playbackModules = this.config["playbackModules"];
    
        foreach(string moduleName; playbackModules) {
            if (moduleName == "mpv") {
                handler.loadModule(new MpvModule());
            }
        }
    }
}

final class FeatureModuleLoader {
    dyaml.Node config;

    this(dyaml.Node config) {
        this.config = config;
    }

    void loadModules(RequestHandler *handler) {
        auto featureModules = this.config["features"];
    
        foreach(string featureName; featureModules) {
            if  (featureName == "youtube") {
                Nullable!YoutubePlayback playbackModule = handler.findYoutubeModule();
                if (!playbackModule.isNull()) {
                    handler.loadModule(new YoutubeModule(playbackModule.get()));
                } else {
                    // TODO crash and burn
                }
            }

            if  (featureName == "soundcloud") {
                Nullable!SoundcloudPlayback playbackModule = handler.findSoundcloudModule();
                if (!playbackModule.isNull()) {
                    handler.loadModule(new SoundcloudModule(playbackModule.get()));
                } else {
                    // TODO crash and burn
                }
            }
        }
    }
}