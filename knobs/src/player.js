import { playUrl, tuneRadio, playSoundcloud, playYoutube } from "./stereo/play.js";

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

    async playYoutube(url) {
        await playYoutube(url);
        // wait a tiny bit, so that it can start playing
        await sleep(1000);
        this.displayComponent.current.updateDisplay();
    }

    async playSoundcloud(url) {
        await playSoundcloud(url);
        // wait a tiny bit, so that it can start playing
        await sleep(1000);
        this.displayComponent.current.updateDisplay();
    }

    async tuneRadio(radio_id) {
        await tuneRadio(radio_id);
        // wait a tiny bit, so that it can start playing
        await sleep(1000);
        this.displayComponent.current.updateDisplay();
    }
}
