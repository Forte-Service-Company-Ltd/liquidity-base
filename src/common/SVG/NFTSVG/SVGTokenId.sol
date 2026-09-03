// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";
import {SVGUtils} from "./SVGUtils.sol";
import {SVGFontMetrics} from "./SVGFontMetrics.sol";

/// @notice Builds the "ID #N" pill.
library SVGTokenId {
    using Strings for uint256;

    uint256 constant LEFT_PAD = 12;
    uint256 constant RIGHT_PAD = 12;
    string constant LABEL = "ID";

    /// @notice returns the token ID of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateSVGTokenId(SVGParams memory params) internal pure returns (string memory svg) {
        string memory idValue = string(abi.encodePacked(" #", params.tokenId.toString()));
        uint labelWidth = SVGFontMetrics.measureWidth(LABEL, 16, 0);
        uint valueWidth = SVGFontMetrics.measureWidth(idValue, 16, 0);
        uint width = LEFT_PAD + labelWidth + valueWidth + RIGHT_PAD;
        uint valueX = 40 + LEFT_PAD + labelWidth;
        svg = string(
            abi.encodePacked(
                SVGUtils.pillRect("392", width.toString()),
                SVGUtils.textTag("#999999", "16", "0px", "52", "413.52", LABEL),
                SVGUtils.textTag("white", "16", "0px", valueX.toString(), "413.52", idValue)
            )
        );
    }
}
