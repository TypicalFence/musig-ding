export async function tuneRadio(radio_id) {
    const options = {
        method: "PUT",
        body: JSON.stringify({ station: radio_id }),
        headers: {
            "Content-Type": "application/json"
        }
    };
    const response = await fetch("/api/v1/radio/tune", options);

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while trying to play radio" + radio_id));
    }
}

export async function playUrl(url) {
    const options = {
        method: "PUT",
        body: JSON.stringify({ url }),
        headers: {
            "Content-Type": "application/json"
        }
    };
    const response = await fetch("/api/v1/play/remotefile", options);

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while trying to play " + url));
    }
}

export async function playYoutube(url) {
    const options = {
        method: "PUT",
        body: JSON.stringify({ url }),
        headers: {
            "Content-Type": "application/json"
        }
    };
    const response = await fetch("/api/v1/play/youtube", options);

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while trying to play " + url));
    }
}

export async function playSoundcloud(url) {
    const options = {
        method: "Put",
        body: JSON.stringify({ url }),
        headers: {
            "Content-Type": "application/json"
        }
    };
    const response = await fetch("/api/v1/play/soundcloud", options);

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while trying to play " + url));
    }
}
