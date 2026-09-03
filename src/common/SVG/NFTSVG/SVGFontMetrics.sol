// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @notice Measures rendered text width for the "Helvetica, Arial, sans-serif" font stack used
/// throughout the NFT SVG, so background "pill" rects can be sized to exactly fit their text
/// (with explicit padding) instead of guessing at a flat per-character average.
/// @dev CHAR_WIDTH_AT_200 holds the advance width, in px, of each printable ASCII character
/// (32 " " through 126 "~") as it actually renders at font-size 200 in Chromium/Arial - the
/// widest commonly-available metric-compatible match for "Helvetica, Arial, sans-serif" that
/// real wallets and browsers use. Advance widths scale linearly with font-size, so measuring at
/// a large reference size and dividing down keeps sub-pixel precision without needing a
/// separate table per font-size used in the SVG (14/16/24/72/96).
library SVGFontMetrics {
    uint256 constant REF_SIZE = 200;
    // Safe (wide) fallback for any byte outside the measured printable-ASCII range (32-126),
    // e.g. non-ASCII UTF-8 continuation bytes in a token symbol - biased wide so unmeasured
    // characters never cause underestimation/overflow.
    uint256 constant FALLBACK_WIDTH = 150;

    bytes constant CHAR_WIDTH_AT_200 =
        hex"3838476f6fb2852643434e75384338386f6f6f6f6f6f6f6f6f6f38387575756fcb85859090857a9c903864856fa7909c859c90857a9085bd85857a3838385e6f436f6f646f6f386f6f2c2c642ca76f6f6f6f4364386f649064646443344375";

    /// @notice Width (in px) of `s` rendered at `fontSize`, with `letterSpacingTenths` (tenths of
    /// a px) added after every character - matching how SVG letter-spacing actually measures in
    /// practice. Rounds up, never down, so a pill sized from this is guaranteed to fully contain
    /// its text.
    function measureWidth(string memory s, uint256 fontSize, uint256 letterSpacingTenths) internal pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 sum;
        for (uint256 i = 0; i < b.length; i++) {
            uint8 c = uint8(b[i]);
            sum += (c >= 32 && c <= 126) ? uint8(CHAR_WIDTH_AT_200[c - 32]) : FALLBACK_WIDTH;
        }
        uint256 deciPx = (sum * fontSize * 10) / REF_SIZE + b.length * letterSpacingTenths;
        return (deciPx + 9) / 10;
    }
}
