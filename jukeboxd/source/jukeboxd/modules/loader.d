module jukeboxd.modules.loader;

import dyaml = dyaml;
import jukeboxd.handler; 
import jukeboxd.modules.mpv; 

final class ModuleLoader {
    dyaml.Node config;

    this(dyaml.Node config) {
        this.config = config;
    }

    void loadModules(RequestHandler *handler) {
        auto playbackModules = this.config["playbackModules"];
    
        foreach(string moduleName; playbackModules) {
            if (moduleName == "mpv") {
                handler.registerProvider(new MpvModule());
            }
        }
    }
}
