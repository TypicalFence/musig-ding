import CONFIG from "../config.js";

const features = CONFIG.features;

const supportsFeature = (feature) => features.includes(feature);

export const youtubeSupport = supportsFeature("youtube");
export const soundcloudSupport = supportsFeature("soundcloud");
export const localFileSupport = supportsFeature("localfiles");
export const remoteFileSupport = supportsFeature("remotefiles");
export const radioSupport = supportsFeature("radio") && remoteFileSupport;
