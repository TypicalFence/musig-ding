module jukeboxd.notifier.factory;

import jukeboxd.notifier : Notifier;
import jukeboxd.notifier.stdout;

class NotifierFactory {
    Notifier build(string name) {
        if (name == "stdout") {
            return new StdOutNotifier();
        }

        return null;
    }
}