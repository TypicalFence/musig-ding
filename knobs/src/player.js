import { playUrl } from "./stereo/player.js";

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

export default class Player {
    constructor() {
        this.displayComponent = null;
    }

    setDisplay(component) {
        this.displayComponent = component;
    }

    async playUrl(url) {
        await playUrl(url);
        // wait a tiny bit, so that it can start playing
        await sleep(1000);
        this.displayComponent.current.updateDisplay();
    }
}
