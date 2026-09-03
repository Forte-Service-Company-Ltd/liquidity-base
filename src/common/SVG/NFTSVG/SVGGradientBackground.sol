// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {SVGParams} from "./SVGTypes.sol";

/// @notice Builds the two blurred gradient circles behind the card.
library SVGGradientBackground {
    function generateSVGDefsCoordinatesAndColor1(SVGParams memory params) internal pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="420" height="560" viewBox="0 0 420 560" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<g clip-path="url(#clip0_2943_19260)">',
                '<rect width="420" height="560" rx="32" fill="black"/>',
                '<g filter="url(#filter0_f_2943_19260)">',
                '<circle cx="',
                params.x1,
                '" cy="',
                params.y1,
                '" r="281" fill="#',
                params.color0,
                '"/></g>'
            )
        );
    }

    function generateSVGDefsCoordinatesAndColor2(SVGParams memory params) internal pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g opacity="0.8" filter="url(#filter1_f_2943_19260)">',
                '<circle cx="',
                params.x2,
                '" cy="',
                params.y2,
                '" r="319" fill="#',
                params.color1,
                '"/></g>'
            )
        );
    }
}
