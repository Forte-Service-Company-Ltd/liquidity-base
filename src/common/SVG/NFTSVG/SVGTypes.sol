// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @notice Parameters needed to render the Liquidity Position NFT SVG image.
struct SVGParams {
    string xToken;
    string yToken;
    string xTokenSymbol;
    string yTokenSymbol;
    string feeTier;
    uint256 tokenId;
    string poolAddress;
    string color0;
    string color1;
    string x1;
    string y1;
    string x2;
    string y2;
}
