const fs = require('fs');
const path = require('path');
const glob = require('glob');

const destDir = path.resolve(path.dirname(__filename), '../dist');

if (!fs.existsSync(destDir)) {
  fs.mkdirSync(destDir, { recursive: true });
}

// Copy index.html
fs.copyFileSync("index.html", path.join(destDir, "index.html"));
fs.copyFileSync("style.css", path.join(destDir, "style.css"));

// Copy JS
let jsdir = path.join(destDir, "js")
if (!fs.existsSync(jsdir)) {
  fs.mkdirSync(jsdir, { recursive: true });
}
glob("src/js/*.js", (err, matches) => {
  matches.forEach(file => {
    destPath = path.join(jsdir, path.basename(file))
    fs.copyFileSync(file, destPath);
  });
});

// Copy Contract
let contractDir = path.join(destDir, "contracts")
if (!fs.existsSync(contractDir)) {
  fs.mkdirSync(contractDir, { recursive: true });
}
fs.copyFileSync("build/contracts/SupplyChain.json", path.join(contractDir, "SupplyChain.json"));
