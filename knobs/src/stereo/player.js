export async function playUrl(url) {
    const options = {
        method: "POST",
        body: JSON.stringify({ url }),
        headers: {
            "Content-Type": "application/json"
        }
    };
    const response = await fetch("/api/player/play", options);

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while trying to play " + url));
    }
}

export async function fetchPlayerStatus() {
    const response = await fetch("/api/player/status");

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while fetching player status"));
    }
}
