import fs from "fs";
import YAML from "yaml";

export const CONFIG_PATH = "/etc/musig.yml";
const CONFIG = YAML.parse(fs.readFileSync(CONFIG_PATH, { encoding: "utf8", flag: "r" }));

export default CONFIG;
