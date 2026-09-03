// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";
import {SVGUtils} from "./SVGUtils.sol";
import {SVGFontMetrics} from "./SVGFontMetrics.sol";

/// @notice Builds the token-pair ticker header (e.g. "USDC / WETH") and the large fee-tier percentage text.
library SVGHeader {
    using Strings for uint256;

    uint256 constant LEFT_PAD = 16;
    uint256 constant RIGHT_PAD = 16;

    /// @notice returns the token pair header of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateSVGTokenPairHeader(SVGParams memory params) internal pure returns (string memory svg) {
        string memory pairText = string(abi.encodePacked(params.xTokenSymbol, " / ", params.yTokenSymbol));
        uint width = LEFT_PAD + SVGFontMetrics.measureWidth(pairText, 24, 0) + RIGHT_PAD;
        uint textX = SVGUtils.CARD_CONTENT_X + LEFT_PAD;
        svg = string(
            abi.encodePacked(
                '<rect x="',
                SVGUtils.CARD_CONTENT_X.toString(),
                '" y="56" width="',
                width.toString(),
                '" height="48" rx="16" fill="black" fill-opacity="0.6"/>',
                SVGUtils.textTag("white", "24", "0px", textX.toString(), "88", pairText)
            )
        );
    }

    function generateFeeTier(SVGParams memory params) internal pure returns (string memory svg) {
        string memory x = SVGUtils.CARD_CONTENT_X.toString();
        if (keccak256(abi.encodePacked(params.feeTier)) == keccak256(abi.encodePacked("INACTIVE"))) {
            svg = SVGUtils.textTag("white", "72", "0px", x, "197.117", params.feeTier);
        } else {
            svg = SVGUtils.textTag("white", "96", "0px", x, "197.117", params.feeTier);
        }
    }
}
