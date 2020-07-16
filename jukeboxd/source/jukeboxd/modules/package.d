module jukeboxd.modules;

import dyaml = dyaml;
import jukeboxd.protocol : MethodProvider;
import jukeboxd.player : PlaybackPlayerApi;

interface Module {
    string getName();
}

abstract class PlaybackModule : Module {
    protected PlaybackPlayerApi player;

    this(PlaybackPlayerApi player) {
        this.player = player;
    }

    protected void emitPlaybackChangeEvent() {
        this.player.onPlaybackChange(this.getName());
    }

    abstract bool isPlaying();
    abstract PlaybackInfo getPlaybackInfo();
    abstract int stopPlayback();
}

interface FeatureModule : Module, MethodProvider {}

interface YoutubePlayback {
    void playYoutubeUrl(string url);
}

interface SoundcloudPlayback {
    void playSoundcloudUrl(string url);
}

interface LocalFilePlayback {
    void playLocalFile(string path);
}

interface RemoteFilePlayback {
    void playRemoteFileUrl(string url);
}

struct PlaybackInfo {
    string url;
    bool playing;
    MediaInfo media;
}

struct MediaInfo {
    string artist;
    string song;
}
