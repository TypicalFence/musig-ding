import fs from "fs";
import Koa from "koa";
import KoaRouter from "@koa/router";
import KoaBody from "koa-logger";
import KoaLogger from "koa-body";
import JukeboxClient from "./lib/jukeboxd.js";
import YAML from 'yaml'

const CONFIG_PATH = "/etc/musig.yml";
const CONFIG = YAML.parse(fs.readFileSync(CONFIG_PATH, {encoding:'utf8', flag:'r'}));


const app = new Koa();
const router =  KoaRouter();
const jukeboxd = new JukeboxClient(CONFIG["jukeboxd"]["socketPath"]);


app.use(KoaLogger());
app.use(KoaBody());

router.post("/player/play", async (ctx) => {
    const { request } = ctx;
    const juke_resp = await jukeboxd.request("mpv_play", request.body.url);
    console.log(juke_resp);
    ctx.body = juke_resp;
});

router.post("/player/stop", async (ctx) => {
    const juke_resp = await jukeboxd.request("mpv_stop");
    console.log(juke_resp);
    ctx.body = juke_resp;
});

router.get("/player/status", async (ctx) => {
    const juke_resp = await jukeboxd.request("mpv_info");
    console.log(juke_resp);
    ctx.body = juke_resp.result;
});

app.use(router.routes());

app.listen(3000);
