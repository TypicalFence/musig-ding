import fs from "fs";
import JukeboxClient from "./lib/jukeboxd.js";
import YAML from 'yaml'

const CONFIG_PATH = "/etc/musig.yml";
const CONFIG = YAML.parse(fs.readFileSync(CONFIG_PATH, {encoding:'utf8', flag:'r'}));
const jukeboxd = new JukeboxClient(CONFIG["jukeboxd"]["socketPath"]);

//jukeboxd.request("yt_play", "https://www.youtube.com/watch?v=Wn5pIY-j2To");
//jukeboxd.request("mpv_play", "/home/fence/Music/Vicetone_Tony_Igy_Astronomia(aka_Coffin_Dance)_Camellia_Remix.mp3");
//jukeboxd.request("mpv_play", "/home/fence/Videos/1473391548.webm");
//jukeboxd.request("mpv_play", "https://lainon.life/radio/cyberia.mp3.m3u");
jukeboxd.request("sc_play", "https://soundcloud.com/n1k-o/popcorn-sega-genesis");
