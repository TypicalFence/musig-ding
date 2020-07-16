module jukeboxd.notifier.manager;

import std.stdio;
import std.uuid;
import vibe.data.bson : Bson;
import dyaml = dyaml;
import jukeboxd.protocol;
import jukeboxd.notifier : Notifier;
import jukeboxd.notifier.factory;

class NotifierManager {
    Notifier[] notifiers;

    this(dyaml.Node config) {
        auto notifiers = config["notifiers"];
        auto factory = new NotifierFactory(); 

        foreach(string notifierName; notifiers) {
            Notifier notifier = factory.build(notifierName);

            if (notifier !is null) {
                this.notifiers ~= notifier;
                writeln("loading notifier: " ~ notifierName);
            }
        }
    }

    public void notify(MessageKind kind, Bson data) {
        string id = randomUUID().toString();
        
        Message msg = Message(id, Type.MESSAGE, kind, data);

        foreach(Notifier notifier; this.notifiers) {
            notifier.notify(msg);
        }
    }
}
