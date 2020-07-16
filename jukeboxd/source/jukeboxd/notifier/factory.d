module jukeboxd.notifier.factory;

import jukeboxd.notifier : Notifier;
import jukeboxd.notifier.stdout;
import jukeboxd.notifier.socks;

class NotifierFactory {
    Notifier build(string name) {
        if (name == "stdout") {
            return new StdOutNotifier();
        }

        if (name == "socks") {
            return new SocksNotifier();
        }

        return null;
    }
}