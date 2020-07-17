export async function fetchPlayerStatus() {
    const response = await fetch("/api/v1/player/status");

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while fetching player status"));
    }
}

export async function stopPlayer() {
    const response = await fetch("/api/v1/player/stop", { method: "PUT" });

    if (response.ok) {
        return response.json();
    } else {
        Promise.reject(new Error("error while fetching player status"));
    }
}
