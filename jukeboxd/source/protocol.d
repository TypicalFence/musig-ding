import vibe.data.bson : Bson;
import protocol;

struct Request {
    string id;
    string type;
    string method;
}

struct MethodResult {
    uint code;
    Bson data;
}

interface Method {
    string getName();
    MethodResult run(Request);
}

interface MethodProvider {
    Method[] getMethods(); 
}
