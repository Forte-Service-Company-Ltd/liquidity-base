# liquidity-base

## Generating the Liquidity Position NFT SVG

The Liquidity Position NFT's image is generated on-chain (see [`src/common/SVG/NFTSVG/`](src/common/SVG/NFTSVG/)) and only exists as a base64-encoded SVG inside the token's `tokenURI`. To inspect what it actually looks like, render it locally:

**1. Generate a sample `tokenURI`**

[`test/util/ScratchRender.t.sol`](test/util/ScratchRender.t.sol) builds a sample NFT (USDC/WstETH, fee 1.00%, token ID 1) and writes its `tokenURI` to `scratch_tokenuri.txt`:

```bash
forge test --match-contract ScratchRenderTest -vv
```

To render a *different* pool/token instead, either edit the symbols/fee/token ID in that test file, or write your own script that calls `Descriptor.constructTokenURI(tokenId, poolAddress, isInactive)`.

**2. Decode the `tokenURI` into an `.svg` file**

The `tokenURI` is a base64 JSON blob whose `image` field is itself a base64-encoded SVG. [`script/dev/decode-tokenuri.js`](script/dev/decode-tokenuri.js) decodes both layers, prints the `name`/`description` fields, and writes the SVG out:

```bash
node script/dev/decode-tokenuri.js scratch_tokenuri.txt scratch_nft.svg
```

You can open `scratch_nft.svg` directly in a browser to view it — a browser is the most accurate way to check it, since it's what wallets/marketplaces actually use.

**3. (Optional) Render a PNG**

```bash
npx --yes resvg-cli scratch_nft.svg scratch_nft.png
```

Note: no SVG rasterizer tested renders this file with perfect fidelity — `resvg-cli` renders the animated `<textPath>` border text correctly but doesn't fully render the blurred gradient background filters, while `rsvg-convert` (`brew install librsvg`) does the gradient correctly but doesn't render `<textPath>` at all. Treat either PNG as a rough check, not a final visual sign-off — use a browser for that.
