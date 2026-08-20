// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";

/// @notice Builds the token-pair ticker header (e.g. "USDC / WETH") and the large fee-tier percentage text.
library SVGHeader {
    using Strings for uint256;

    /// @notice returns the token pair header of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateSVGTokenPairHeader(SVGParams memory params) internal pure returns (string memory svg) {
        string memory pairText = string(abi.encodePacked(params.xTokenSymbol, " / ", params.yTokenSymbol));
        uint width = (bytes(pairText).length) * 15 + 20;
        svg = string(
            abi.encodePacked(
                '<rect x="48" y="56" width="',
                width.toString(),
                '" height="38" rx="10" fill="black" fill-opacity="0.6"/>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="24" letter-spacing="0px"><tspan x="60" y="82">',
                pairText,
                "</tspan></text>"
            )
        );
    }

    function generateFeeTier(SVGParams memory params) internal pure returns (string memory svg) {
        if (keccak256(abi.encodePacked(params.feeTier)) == keccak256(abi.encodePacked("INACTIVE"))) {
            svg = string(
                abi.encodePacked(
                    '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="72" letter-spacing="0px"><tspan x="48" y="193.117">',
                    params.feeTier,
                    "</tspan></text>"
                )
            );
        } else {
            svg = string(
                abi.encodePacked(
                    '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="96" letter-spacing="0px"><tspan x="48" y="193.117">',
                    params.feeTier,
                    "</tspan></text>"
                )
            );
        }
    }
}
