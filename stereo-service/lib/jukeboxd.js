import net from "net";
import promise_socket from "promise-socket";
import BSON from "bson";
import { v4 as uuidv4 } from "uuid";

const { PromiseSocket } = promise_socket;

function create_socket() {
    const socket = new net.Socket();
    const promiseSocket = new PromiseSocket(socket);
    return promiseSocket;
}

async function make_request(addr, id, method, params) {
    const socket = create_socket();
    let request;
    if (params === null) {
        request = BSON.serialize({ id, type: "request", method });
    } else {
        request = BSON.serialize({ id, type: "request", method, params });
    }
    await socket.connect(addr);
    await socket.write(request);

    const response_bytes = await socket.readAll();
    const response = BSON.deserialize(response_bytes);
    await socket.destroy();

    return response;
}

export default class JukeboxClient {
    constructor(addr) {
        this.address = addr;
    }

    request(method, params = null, id = null) {
        let request_id = id;

        if (request_id === null) {
            request_id = uuidv4();
        }

        console.log(params);
        return make_request(this.address, request_id, method, params);
    }
}
