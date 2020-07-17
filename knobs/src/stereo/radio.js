export class RadioStation {
    constructor({ name, url, color, id }) {
        this.name = name;
        this.url = url;
        this.color = color;
        this.id = id;
    }
}

export async function fetchRadioStations() {
    const response = await fetch("/api/v1/radio/stations");

    if (response.ok) {
        const data = await response.json();
        return data.map(x => new RadioStation(x));
    } else {
        Promise.reject(new Error("error while fetching radio stations"));
    }
}
