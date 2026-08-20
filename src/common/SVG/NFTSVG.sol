// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// This file is kept as a stable import path (`Descriptor`, `SVG`, `SVGLinesPart1/2/3`, `HexStrings`
// all still resolve from "src/common/SVG/NFTSVG.sol"). The actual implementation lives in
// src/common/SVG/NFTSVG/, split by responsibility:
//
//   SVGTypes.sol              - shared SVGParams struct
//   SVGTopoLinesPart1/2/3.sol - topographic line-art background overlay path data
//   SVGGradientBackground.sol - the two blurred gradient circles behind the card
//   SVGHeader.sol             - ticker header + large fee-tier percentage text
//   SVGTokenId.sol            - the "ID #N" pill
//   SVGTokenFields.sol        - the TKNX / TKNY pills
//   SVGBorderText.sol         - animated "Pool - 0x..." border text + shared <defs>
//   SVGUtils.sol              - small shared string helpers
//   SVGCore.sol               - `SVG` library: assembles the pieces above into the full SVG
//   Descriptor.sol            - `Descriptor` library: builds the tokenURI JSON (name/description/image)
//   HexStrings.sol            - fixed-length hex string conversion
import "./NFTSVG/SVGTypes.sol";
import "./NFTSVG/SVGTopoLinesPart1.sol";
import "./NFTSVG/SVGTopoLinesPart2.sol";
import "./NFTSVG/SVGTopoLinesPart3.sol";
import "./NFTSVG/SVGUtils.sol";
import "./NFTSVG/SVGGradientBackground.sol";
import "./NFTSVG/SVGHeader.sol";
import "./NFTSVG/SVGTokenId.sol";
import "./NFTSVG/SVGTokenFields.sol";
import "./NFTSVG/SVGBorderText.sol";
import "./NFTSVG/SVGCore.sol";
import "./NFTSVG/HexStrings.sol";
import "./NFTSVG/Descriptor.sol";
