import Koa from "koa";
import KoaBody from "koa-logger";
import KoaLogger from "koa-body";
import generalRouter from "./routes/general.js";
import playerRouter from "./routes/player.js";
import playRouter from "./routes/play.js";
import { notFound, internalError } from "./lib/responses.js";

const app = new Koa();

app.use(KoaLogger());
app.use(KoaBody());

app.use(generalRouter.routes());
app.use(playerRouter.routes());
app.use(playRouter.routes());

// error handlers
app.use(async(ctx, next) => {
    if (parseInt(ctx.status) === 404) {
        notFound(ctx);
    }

    if (parseInt(ctx.status) === 500) {
        internalError(ctx);
    }
});

console.log("listening on port 3000");
app.listen(3000);
