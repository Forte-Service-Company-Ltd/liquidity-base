# liquidity-base

## Generating the Liquidity Position NFT SVG

The Liquidity Position NFT's image is generated on-chain (see [`src/common/SVG/NFTSVG/`](src/common/SVG/NFTSVG/)) and only exists as a base64-encoded SVG inside the token's `tokenURI`. To inspect what it actually looks like, render it locally:

**1. Generate a sample `tokenURI`**

There's no permanent test for this (a scratch test with no assertions doesn't belong in `test/`), so write a temporary one that builds a pool and prints its `tokenURI` with `console.log`, e.g.:

```solidity
// test/util/Scratch.t.sol (temporary - don't commit)
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "src/common/SVG/NFTSVG.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
}

contract MockPool {
    address public xToken;
    address public yToken;
    uint16 public fee;

    constructor(address _xToken, address _yToken, uint16 _fee) {
        xToken = _xToken;
        yToken = _yToken;
        fee = _fee;
    }

    function getFeeInfo() external view returns (uint16, uint16, address, address, uint256) {
        return (fee, 0, address(0), address(0), 0);
    }
}

contract ScratchTest is Test {
    function test_render() public {
        ERC20 usdc = new MockERC20("USDC", "USDC");
        ERC20 wsteth = new MockERC20("WstETH", "WstETH");
        MockPool pool = new MockPool(address(usdc), address(wsteth), 100);
        console.log(Descriptor.constructTokenURI(1, address(pool), false));
    }
}
```

```bash
forge test --match-contract ScratchTest -vv
```

Copy the printed `tokenURI` string into a local file named `scratch_tokenuri.txt` (the `scratch_*` prefix is gitignored, so it and the temporary test file above are discardable, not part of the repo).

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
