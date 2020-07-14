import KoaRouter from "@koa/router";
import CONFIG from "../config.js";
import JukeboxClient from "../lib/jukeboxd.js";
import { youtubeSupport, soundcloudSupport, remoteFileSupport } from "../lib/features.js";
import { notImplemented, badRequest } from "../lib/responses.js";

const jukeboxd = new JukeboxClient(CONFIG.jukeboxd.socketPath);
const router = KoaRouter();

router.put("/api/v1/play/youtube", async(ctx) => {
    if (youtubeSupport) {
        const { url } = ctx.request.body;
        if (url) {
            const juke_resp = await jukeboxd.request("yt_play", url);
            ctx.body = juke_resp;
        } else {
            badRequest(ctx);
        }
    } else {
        notImplemented(ctx);
    }
});

router.put("/api/v1/play/soundcloud", async(ctx) => {
    if (soundcloudSupport) {
        const { url } = ctx.request.body;
        if (url) {
            const juke_resp = await jukeboxd.request("sc_play", url);
            ctx.body = juke_resp;
        } else {
            badRequest(ctx);
        }
    } else {
        notImplemented(ctx);
    }
});

router.put("/api/v1/play/remotefile", async(ctx) => {
    if (remoteFileSupport) {
        const { url } = ctx.request.body;
        if (url) {
            const juke_resp = await jukeboxd.request("remotefile_play", url);
            ctx.body = juke_resp;
        } else {
            badRequest(ctx);
        }
    } else {
        notImplemented(ctx);
    }
});

export default router;
