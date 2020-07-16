module jukeboxd.notifier.fiber;

import core.thread : Fiber, Thread, dur;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.protocol;
import jukeboxd.player;
import jukeboxd.notifier.manager;

// NOTE: this is just an experiemnt
class PlaybackChangeFiber : Fiber {
    private NotifierManager notifier;
    private Player player;

    this(Player player, NotifierManager notifier) {
        this.player = player;
        this.notifier = notifier;
        super(&run);
    }

    void run() {
        // wait a bit because we might be playing a network stream;
        Thread.sleep(dur!("seconds")(1));
        auto info = player.getPlayingModule().getPlaybackInfo();
        notifier.notify(MessageKind.PLAYBACK, serializeToBson(info));
    }
}
