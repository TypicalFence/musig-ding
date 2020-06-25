module jukeboxd.modules;

import dyaml = dyaml;

interface Module {
    string getName();
    int stopPlayback();
}

public import jukeboxd.modules.loader;
