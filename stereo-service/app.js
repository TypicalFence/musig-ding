import Koa from "koa";
import KoaRouter from "@koa/router";
import KoaBody from "koa-logger";
import KoaLogger from "koa-body";
import net from "net";
import promise_socket from "promise-socket";
import BSON from "bson";

const { PromiseSocket } = promise_socket;

console.log(PromiseSocket);

const app = new Koa();
const router =  KoaRouter();

app.use(KoaLogger());
app.use(KoaBody());

router.get("/", (ctx) => {
    ctx.body = "hewwo world";
});

router.post("/play", async (ctx) => {
    const { request } = ctx;
    const socket = new net.Socket()
    const promiseSocket = new PromiseSocket(socket)
    await promiseSocket.connect("/tmp/jukeboxd")
    await promiseSocket.write(BSON.serialize({id: "lol", type:"request", "method": "mpv_play", "params": request.body.url}));
    const content = await promiseSocket.readAll();
    console.log(BSON.deserialize(content));
    await promiseSocket.destroy();
    ctx.body = { "yay": "yay" };
});

router.get("/stop", async (ctx) => {
    const { request } = ctx;
    const socket = new net.Socket()
    const promiseSocket = new PromiseSocket(socket)
    await promiseSocket.connect("/tmp/jukeboxd")
    await promiseSocket.write(BSON.serialize({id: "lol", type:"request", "method": "mpv_stop"}))
    const content = await promiseSocket.readAll();
    console.log(BSON.deserialize(content));
    await promiseSocket.destroy();
    ctx.body = { "yay": "yay" };
});

router.get("/info", async (ctx) => {
    const { request } = ctx;
    const socket = new net.Socket()
    const promiseSocket = new PromiseSocket(socket)
    await promiseSocket.connect("/tmp/jukeboxd")
    await promiseSocket.write(BSON.serialize({id: "lol", type:"request", "method": "mpv_info"}))
    const content = await promiseSocket.readAll();
    const content_json = BSON.deserialize(content);
    console.log(content_json);
    await promiseSocket.destroy();
    ctx.body = content_json.result;
});

router.get("/json", (ctx) => {
    ctx.body = { "hewwo": "I am a json" };
});

router.post("/json", (ctx) => {
    const { request } = ctx;

    ctx.body = { "data": request.body };
});

app.use(router.routes());
app.listen(3000);
