module jukeboxd.protocol;

import vibe.data.serialization : optional;
import vibe.data.bson : Bson;

enum Type : string {
    REQUEST = "request",
    RESPONSE = "response",
}

struct Request {
    string id;
    Type type;
    string method;
    @optional()
    Bson params;
}

struct Response {
    string id;
    Type type;
    int code;
    Bson result;
}

abstract class Method {
    abstract string getName();
    abstract MethodResult run(Request);
}

struct MethodResult {
    uint code;
    Bson data;
}

interface MethodProvider {
    Method[] getMethods(); 
}

