import KoaRouter from "@koa/router";
import JukeboxClient from "../lib/jukeboxd.js";
import CONFIG from "../config.js";

const router = KoaRouter();
const jukeboxd = new JukeboxClient(CONFIG.jukeboxd.socketPath);

router.put("/api/v1/player/stop", async(ctx) => {
    const juke_resp = await jukeboxd.request("player_stop");
    console.log(juke_resp);
    ctx.body = juke_resp;
});

router.get("/api/v1/player/status", async(ctx) => {
    const juke_resp = await jukeboxd.request("player_info");
    console.log(juke_resp);
    ctx.body = juke_resp.result;
});

export default router;
