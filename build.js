import { bundle } from "luabundle";
import luamin from "luamin";
import path from "path";
import fs from "fs";

const projects = ["resolver"];

for (const project of projects) {
  console.log(`Building ${project}...`);

  const out = bundle(path.join("src", project, "main.lua"), {
    paths: ["?", "?.lua", path.join("src", project, "?.lua")],
    ignoredModuleNames: ["io"]
  });
  const minified = luamin.minify(out);

  if (!fs.existsSync("dist")) fs.mkdirSync("dist");
  fs.writeFileSync(path.join("dist", `${project}.lua`), minified);
}

console.log("Done!");
