/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {TestCommonSetup} from "test/util/TestCommonSetup.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve
 */
abstract contract PoolCommonUnitTest is TestCommonSetup {
    IERC20 _yToken;
    bool withStableCoin;
    bool wEth;
    bool wMatic;
    uint fullToken;

    function _setUp(bool _withStableCoin) internal endWithStopPrank {
        pool = _setupStressTestPool(_withStableCoin);
        withStableCoin = _withStableCoin;
        _yToken = IERC20(pool.yToken());
        fullToken = address(_yToken) == address(stableCoin) ? STABLECOIN_DEC : ERC20_DECIMALS;
    }

}