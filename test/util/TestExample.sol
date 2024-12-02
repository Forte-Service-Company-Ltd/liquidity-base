// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {TestCommonSetup} from "test/util/TestCommonSetup.sol";

/**
 * @dev This test suite is for testing the deployed application.
 */
contract ExampleTest is TestCommonSetup {
    function testSetupExample() public {
        _setUpTokens(X_TOKEN_MAX_SUPPLY);
        assertTrue(address(xToken) != address(0x0));
        assertTrue(address(yToken) != address(0x0));
    }
}
