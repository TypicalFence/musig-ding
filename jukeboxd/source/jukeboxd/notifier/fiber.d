module jukeboxd.notifier.fiber;

import core.thread : Fiber, Thread, dur;
import vibe.data.bson : Bson, serializeToBson;
import jukeboxd.protocol;
import jukeboxd.player;
import jukeboxd.modules;
import jukeboxd.notifier.manager;

class PlaybackChangeFiber : Fiber {
    private NotifierManager notifier;
    private Player player;
    private int retries;

    this(Player player, NotifierManager notifier) {
        this.player = player;
        this.notifier = notifier;
        this.retries = 0;
        super(&run);
    }

    void run() {
        // wait a bit because we might be playing a network stream;
        Thread.sleep(dur!("seconds")(10));
        PlaybackModule mod = player.getPlayingModule();

        if (mod !is null) {
            notifier.notify(MessageKind.PLAYBACK, serializeToBson(mod.getPlaybackInfo()));
        } else {
            if (retries > 10) {
                this.run();
            }
        }
    }
}
