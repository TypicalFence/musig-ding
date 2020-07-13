module jukeboxd.modules;

import dyaml = dyaml;
import jukeboxd.protocol : MethodProvider;

interface Module {
    string getName();
}

interface PlaybackModule : Module {
    int stopPlayback();
}

interface FeatureModule : Module, MethodProvider {}

interface YoutubePlayback {
    void playYoutubeUrl(string url);
}

interface SoundcloudPlayback {
    void playSoundcloudUrl(string url);
}

public import jukeboxd.modules.loader;
