module jukeboxd.notifier.factory;

import dyaml = dyaml;
import jukeboxd.notifier : Notifier;
import jukeboxd.notifier.stdout;
import jukeboxd.notifier.socks;

class NotifierFactory {
    private dyaml.Node config;

    this(dyaml.Node config) {
        this.config = config;
    }

    Notifier build(string name) {
        if (name == "stdout") {
            return new StdOutNotifier();
        }

        if (name == "socks") {
            return new SocksNotifier(config);
        }

        return null;
    }
}