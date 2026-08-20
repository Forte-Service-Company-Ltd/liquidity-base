// Decodes a base64 tokenURI (written by test/util/ScratchRender.t.sol) into a
// readable name/description plus a standalone .svg file you can open or convert to PNG.
//
// Usage:
//   node script/dev/decode-tokenuri.js scratch_tokenuri.txt scratch_nft.svg
const fs = require('fs');

const [, , inFile, outSvg] = process.argv;
if (!inFile || !outSvg) {
  console.error('Usage: node decode-tokenuri.js <tokenuri.txt> <out.svg>');
  process.exit(1);
}

const uri = fs.readFileSync(inFile, 'utf8').trim();
const b64json = uri.replace('data:application/json;base64,', '');
const json = JSON.parse(Buffer.from(b64json, 'base64').toString('utf8'));

console.log('name:', json.name);
console.log('description:', json.description);

const svgb64 = json.image.replace('data:image/svg+xml;base64,', '');
const svg = Buffer.from(svgb64, 'base64').toString('utf8');
fs.writeFileSync(outSvg, svg);
console.log('svg written to', outSvg, '(', svg.length, 'bytes )');
