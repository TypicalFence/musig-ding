const getBody = (ctx) => ({ error: ctx.status });

export function badRequest(ctx) {
    ctx.status = 400;
    ctx.body = getBody(ctx);
}

export function notImplemented(ctx) {
    ctx.status = 501;
    ctx.body = getBody(ctx);
}

export function notFound(ctx) {
    ctx.status = 404;
    ctx.body = getBody(ctx);
}

export function internalError(ctx) {
    ctx.status = 500;
    ctx.body = getBody(ctx);
}
