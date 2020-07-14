import KoaRouter from "@koa/router";
import CONFIG from "../config.js";
import JukeboxClient from "../lib/jukeboxd.js";
import { radioSupport } from "../lib/features.js";
import { notImplemented, badRequest } from "../lib/responses.js";

const jukeboxd = new JukeboxClient(CONFIG.jukeboxd.socketPath);
const router = KoaRouter();

const stations = CONFIG.radio.stations;

router.get("/api/v1/radio/stations", async(ctx) => {
    if (radioSupport) {
        ctx.body = stations;
    } else {
        notImplemented(ctx);
    }
});

router.put("/api/v1/radio/tune", async(ctx) => {
    console.log(radioSupport);
    if (radioSupport) {
        const { station } = ctx.request.body;
        if (station) {
            const stationObj = stations.find(x => x.id === station);

            if (stationObj) {
                const juke_resp = await jukeboxd.request("remotefile_play", stationObj.url);
                ctx.body = juke_resp;
            } else {
                badRequest(ctx);
            }
        } else {
            badRequest(ctx);
        }
    } else {
        notImplemented(ctx);
    }
});

router.get("/api/v1/features", async(ctx) => {
    ctx.body = CONFIG.features;
});

export default router;
