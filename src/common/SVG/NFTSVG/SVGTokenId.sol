// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";
import {SVGUtils} from "./SVGUtils.sol";

/// @notice Builds the "ID #N" pill.
library SVGTokenId {
    using Strings for uint256;

    string constant LABEL = "ID";

    /// @notice returns the token ID of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateSVGTokenId(SVGParams memory params) internal pure returns (string memory svg) {
        string memory idValue = string(abi.encodePacked(" #", params.tokenId.toString()));
        svg = SVGUtils.labelValuePill("392", "413.52", LABEL, idValue);
    }
}
