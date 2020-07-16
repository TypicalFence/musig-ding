module jukeboxd.notifier;

import vibe.data.bson : Bson;
import jukeboxd.protocol;

interface Notifier {
    void notify(Message msg);
}

public import jukeboxd.notifier.manager;