module jukeboxd.player;

import std.typecons : Nullable, nullable;
import vibe.data.serialization : optional;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.protocol;
import jukeboxd.modules;

final class Player : MethodProvider {
    private PlaybackModule[] playbackModules; 
    private FeatureModule[] featureModules;

    void addPlaybackModule(PlaybackModule playback) {
        this.playbackModules ~= playback;
    }

    void addFeatureModule(FeatureModule feature) {
        this.featureModules ~= feature;
    }

    void stopAllPlayback() {
        foreach(PlaybackModule mod; this.playbackModules) {
            mod.stopPlayback();
        }
    }

    PlaybackModule getPlayingModule() {
        foreach(PlaybackModule mod; this.playbackModules) {
            if (mod.isPlaying()) {
                return mod;
            }
        }

        return null;
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

    Method[] getMethods() {
        return [
            new PlayerStatusMethod(this),
            new PlayerStopMethod(this),
        ];
    }
}

struct PlayerStatus {
    @optional()
    string activeModule;
    @optional()
    PlaybackInfo playbackinfo;
}

class PlayerStatusMethod : Method {
    private Player player;

    this(Player player) {
        this.player = player;
    }

    override string getName() {
        return "player_info";
    }

    override MethodResult run(Request) {
        PlaybackModule activeModule = this.player.getPlayingModule();
        PlayerStatus status;

        if (activeModule !is null) {
            status.activeModule = activeModule.getName();
            status.playbackinfo = activeModule.getPlaybackInfo();
        }

        return MethodResult(200, serializeToBson(status));
    }
}

class PlayerStopMethod : Method {
    private Player player;

    this(Player player) {
        this.player = player;
    }

    override string getName() {
        return "player_stop";
    }

    override MethodResult run(Request) {
        this.player.stopAllPlayback(); 
        return MethodResult(200, Bson("stopped"));
    }
}