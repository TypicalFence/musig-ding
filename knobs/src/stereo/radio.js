export class RadioStation {
    constructor({ name, url, color }) {
        this.name = name;
        this.url = url;
        this.color = color;
    }
}

export async function fetchRadioStations() {
    const response = await fetch("/api/radio/stations");

    if (response.ok) {
        const data = await response.json();
        return data.map(x => new RadioStation(x));
    } else {
        Promise.reject(new Error("error while fetching radio stations"));
    }
}
