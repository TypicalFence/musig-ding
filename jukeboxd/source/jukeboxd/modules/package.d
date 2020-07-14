module jukeboxd.modules;

import dyaml = dyaml;
import jukeboxd.protocol : MethodProvider;

interface Module {
    string getName();
}

interface PlaybackModule : Module {
    bool isPlaying();
    PlaybackInfo getPlaybackInfo();
    int stopPlayback();
}

interface FeatureModule : Module, MethodProvider {}

interface YoutubePlayback {
    void playYoutubeUrl(string url);
}

interface SoundcloudPlayback {
    void playSoundcloudUrl(string url);
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

public import jukeboxd.modules.loader;
