module jukeboxd.handler;

import vibe.data.bson : Bson;
import jukeboxd.protocol;

struct RequestHandler {
    private Method[string] methods;
    
    public void registerProvider(MethodProvider provider) {
        foreach(method; provider.getMethods()) {
            this.methods[method.getName()] = method;
        }
    }

    public MethodResult handle_request(Request req) {
        Method method = this.methods.get(req.method, null);
        
        if(method !is null) {
            return method.run(req);
        }

        return MethodResult(404, Bson(null));
    }
}
