module jukeboxd.notifier.stdout;

import std.stdio;
import jukeboxd.protocol;
import jukeboxd.notifier;

class StdOutNotifier : Notifier {
    public void notify(Message msg) {
        writeln(msg);
    }
}