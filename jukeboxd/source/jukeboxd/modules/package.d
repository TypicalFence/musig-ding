module jukeboxd.modules;

import dyaml = dyaml;
import jukeboxd.protocol : MethodProvider;

interface PlaybackModule {
    string getName();
    int stopPlayback();
}

interface FeatureModule : MethodProvider {
    string getName();
}

interface YoutubePlayback {
    void playYoutubeUrl(string url);
}

interface SoundcloudPlayback {
    void playSoundcloudUrl(string url);
}

public import jukeboxd.modules.loader;
