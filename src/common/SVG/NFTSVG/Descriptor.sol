// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {IPool} from "src/amm/base/IPool.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SVG} from "./SVGCore.sol";
import {SVGParams} from "./SVGTypes.sol";
import {HexStrings} from "./HexStrings.sol";

/// @notice Builds the tokenURI JSON (name, description, base64 SVG image) for a Liquidity Position NFT.
library Descriptor {
    using Strings for uint256;
    using HexStrings for uint256;

    struct ConstructTokenURIParams {
        uint256 tokenId;
        address xTokenAddress;
        address yTokenAddress;
        string xTokenSymbol;
        string yTokenSymbol;
        uint16 fee;
        address poolManager;
        bool isInactive;
    }

    /// @notice Constructs the token URI for a ALTBC NFT
    /// @param tokenId The token ID
    /// @return The token URI as a string
    function constructTokenURI(uint256 tokenId, address poolAddress, bool isInactive) external view returns (string memory) {
        IPool pool = IPool(poolAddress);
        (uint16 _fee, , , , ) = pool.getFeeInfo();

        ConstructTokenURIParams memory params = ConstructTokenURIParams({
            tokenId: tokenId,
            xTokenAddress: pool.xToken(),
            yTokenAddress: pool.yToken(),
            xTokenSymbol: IERC20Metadata(pool.xToken()).symbol(),
            yTokenSymbol: IERC20Metadata(pool.yToken()).symbol(),
            fee: _fee,
            poolManager: address(pool),
            isInactive: isInactive
        });
        string memory name = generateName(params, feeToPercentString(params.fee, isInactive));
        string memory descriptionPartOne = generateDescriptionPartOne(
            escapeSpecialCharacters(params.xTokenSymbol),
            escapeSpecialCharacters(params.yTokenSymbol),
            addressToString(params.poolManager)
        );
        string memory descriptionPartTwo = generateDescriptionPartTwo(
            params.tokenId.toString(),
            escapeSpecialCharacters(params.xTokenSymbol),
            params.yTokenAddress == address(0) ? "Native" : addressToString(params.yTokenAddress),
            params.xTokenAddress == address(0) ? "Native" : addressToString(params.xTokenAddress)
        );

        string memory image = Base64.encode(bytes(generateSVGImage(params)));

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"',
                                descriptionPartOne,
                                descriptionPartTwo,
                                '", "image": "data:image/svg+xml;base64,',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    /// @notice Escapes special characters in a string if they are present
    /// @param symbol The string to escape special characters from
    /// @return The string with special characters escaped
    function escapeSpecialCharacters(string memory symbol) internal pure returns (string memory) {
        bytes memory symbolBytes = bytes(symbol);
        uint8 specialCharCount = 0;
        // count the amount of double quotes, form feeds, new lines, carriage returns, or tabs in the symbol
        for (uint8 i = 0; i < symbolBytes.length; i++) {
            if (isSpecialCharacter(symbolBytes[i])) {
                specialCharCount++;
            }
        }
        if (specialCharCount > 0) {
            // create a new bytes array with enough space to hold the original bytes plus space for the backslashes to escape the special characters
            bytes memory escapedBytes = new bytes(symbolBytes.length + specialCharCount);
            uint256 index;
            for (uint8 i = 0; i < symbolBytes.length; i++) {
                // add a '\' before any double quotes, form feeds, new lines, carriage returns, or tabs
                if (isSpecialCharacter(symbolBytes[i])) {
                    escapedBytes[index++] = "\\";
                }
                // copy each byte from original string to the new array
                escapedBytes[index++] = symbolBytes[i];
            }
            return string(escapedBytes);
        }
        return symbol;
    }

    /// @notice Generates the first part of the description for a ALTBC NFT
    /// @param xTokenSymbol The symbol of the x token
    /// @param yTokenSymbol The symbol of the y token
    /// @param poolManager The address of the pool manager
    /// @return The first part of the description
    function generateDescriptionPartOne(
        string memory xTokenSymbol,
        string memory yTokenSymbol,
        string memory poolManager
    ) private pure returns (string memory) {
        // displays quote currency first, then base currency
        return
            string(
                abi.encodePacked(
                    "This NFT represents a liquidity position in a ALTBC ",
                    xTokenSymbol,
                    "-",
                    yTokenSymbol,
                    " pool. ",
                    "The owner of this NFT can modify or redeem the position.\\n",
                    "\\nPool Manager Address: ",
                    poolManager,
                    "\\n",
                    yTokenSymbol
                )
            );
    }

    /// @notice Generates the second part of the description for a ALTBC NFT
    /// @param tokenId The token ID
    /// @param baseCurrencySymbol The symbol of the base currency
    /// @param quoteCurrency The address of the quote currency
    /// @param baseCurrency The address of the base currency
    /// @return The second part of the description
    function generateDescriptionPartTwo(
        string memory tokenId,
        string memory baseCurrencySymbol,
        string memory quoteCurrency,
        string memory baseCurrency
    ) private pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    " Address: ",
                    quoteCurrency,
                    "\\n",
                    baseCurrencySymbol,
                    " Address: ",
                    baseCurrency,
                    "\\nToken ID: ",
                    tokenId,
                    "\\n\\n",
                    unicode"⚠️ DISCLAIMER: Due diligence is imperative when assessing this NFT. Make sure currency addresses match the expected currencies, as currency symbols may be imitated."
                )
            );
    }

    /// @notice Generates the name for a ALTBC NFT
    /// @param params Parameters needed to generate the name
    /// @param feeTier The fee tier of the pool
    /// @return The name of the NFT
    function generateName(ConstructTokenURIParams memory params, string memory feeTier) private pure returns (string memory) {
        // image shows in terms of price, ie quoteCurrency/baseCurrency
        return
            string(
                abi.encodePacked(
                    "ALTBC - ",
                    feeTier,
                    " - ",
                    escapeSpecialCharacters(params.xTokenSymbol),
                    "/",
                    escapeSpecialCharacters(params.yTokenSymbol)
                )
            );
    }

    /// @notice Converts fee amount in hundredths of a percent (where 100 = 1%) to decimal string with percent sign
    /// @param fee fee amount as uint16 where 100 = 1%, 1 = 0.01%
    /// @param isInactive true if the position is inactive
    /// @return fee as a decimal string with percent sign
    function feeToPercentString(uint16 fee, bool isInactive) internal pure returns (string memory) {
        if (isInactive) {
            return "INACTIVE";
        }

        if (fee == 0) {
            // this is to handle the edge case of the first inactive LP position where it will not earn trading fees
            return "0%";
        }

        // For values less than 100 (< 1%), we need to show with leading zero
        if (fee < 100) {
            // Prepare for decimal < 1%
            if (fee < 10) {
                // Format as "0.0X%" for single-digit values (e.g., 5 -> "0.05%")
                return string(abi.encodePacked("0.0", uint256(fee).toString(), "%"));
            } else {
                // Format as "0.XX%" for double-digit values (e.g., 50 -> "0.50%")
                return string(abi.encodePacked("0.", uint256(fee).toString(), "%"));
            }
        } else {
            // Value is >= 1%
            uint16 whole = fee / 100; // Integer part
            uint16 fraction = fee % 100; // Fractional part

            if (fraction == 0) {
                // No decimal places needed (e.g., 500 -> "5%")
                return string(abi.encodePacked(uint256(whole).toString(), ".00%"));
            } else if (fraction < 10) {
                // Need leading zero in fraction (e.g., 501 -> "5.01%")
                return string(abi.encodePacked(uint256(whole).toString(), ".0", uint256(fraction).toString(), "%"));
            } else {
                // No leading zero needed (e.g., 550 -> "5.50%")
                return string(abi.encodePacked(uint256(whole).toString(), ".", uint256(fraction).toString(), "%"));
            }
        }
    }

    /// @notice Converts an address to a string
    /// @param addr The address to convert
    /// @return The string representation of the address
    function addressToString(address addr) internal pure returns (string memory) {
        return (uint256(uint160(addr))).toHexString(20);
    }

    /// @notice Generates the SVG image for a Uniswap v4 NFT
    /// @param params Parameters needed to generate the SVG image
    /// @return svg The SVG image as a string
    function generateSVGImage(ConstructTokenURIParams memory params) internal pure returns (string memory svg) {
        SVGParams memory svgParams = SVGParams({
            xToken: addressToString(params.xTokenAddress),
            yToken: addressToString(params.yTokenAddress),
            xTokenSymbol: params.xTokenSymbol,
            yTokenSymbol: params.yTokenSymbol,
            feeTier: feeToPercentString(params.fee, params.isInactive),
            poolAddress: addressToString(params.poolManager),
            tokenId: params.tokenId,
            color0: currencyToColorHex(uint256(uint160(params.xTokenAddress)), 136),
            color1: currencyToColorHex(uint256(uint160(params.yTokenAddress)), 136),
            x1: scale(getCircleCoord(uint256(uint160(params.xTokenAddress)), 16, params.tokenId), 0, 255, 16, 274),
            y1: scale(getCircleCoord(uint256(uint160(params.yTokenAddress)), 16, params.tokenId), 0, 255, 100, 484),
            x2: scale(getCircleCoord(uint256(uint160(params.xTokenAddress)), 32, params.tokenId), 0, 255, 16, 274),
            y2: scale(getCircleCoord(uint256(uint160(params.yTokenAddress)), 32, params.tokenId), 0, 255, 100, 484)
        });

        return SVG.generateSVG(svgParams);
    }

    /// @notice Checks if a character is a special character
    /// @param b The character to check
    /// @return True if the character is a special character, false otherwise
    function isSpecialCharacter(bytes1 b) private pure returns (bool) {
        return b == '"' || b == "\u000c" || b == "\n" || b == "\r" || b == "\t";
    }

    /// @notice Scales a number from one range to another
    /// @param n The number to scale
    /// @param inMn The minimum value of the input range
    /// @param inMx The maximum value of the input range
    /// @param outMn The minimum value of the output range
    /// @param outMx The maximum value of the output range
    /// @return The scaled number as a string
    function scale(uint256 n, uint256 inMn, uint256 inMx, uint256 outMn, uint256 outMx) private pure returns (string memory) {
        return (((n - inMn) * (outMx - outMn)) / (inMx - inMn) + outMn).toString();
    }

    function currencyToColorHex(uint256 currency, uint256 offset) internal pure returns (string memory str) {
        return string((currency >> offset).toHexStringNoPrefix(3));
    }

    function getCircleCoord(uint256 currency, uint256 offset, uint256 tokenId) internal pure returns (uint256) {
        return (sliceCurrencyHex(currency, offset) * tokenId) % 255;
    }

    function sliceCurrencyHex(uint256 currency, uint256 offset) internal pure returns (uint256) {
        return uint256(uint8(currency >> offset));
    }
}
