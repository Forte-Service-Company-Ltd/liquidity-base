// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";

/// @notice Builds the "ID #N" pill.
library SVGTokenId {
    using Strings for uint256;

    /// @notice returns the token ID of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateSVGTokenId(SVGParams memory params) internal pure returns (string memory svg) {
        string memory idValue = string(abi.encodePacked("#", params.tokenId.toString()));
        uint width = 12 + 2 * 9 + 10 + (bytes(idValue).length) * 9 + 12;
        uint valueX = 48 + 12 + 2 * 9 + 10;
        svg = string(
            abi.encodePacked(
                '<rect x="48" y="372" width="',
                width.toString(),
                '" height="28" rx="8" fill="black" fill-opacity="0.6"/>',
                '<text fill="#959595" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="16" letter-spacing="0px"><tspan x="60" y="391">ID</tspan></text>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="16" letter-spacing="0px"><tspan x="',
                valueX.toString(),
                '" y="391">',
                idValue,
                "</tspan></text>"
            )
        );
    }
}
