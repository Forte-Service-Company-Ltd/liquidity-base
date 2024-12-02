/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {PoolCommonTest} from "test/amm/common/PoolCommon.t.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {TBCType} from "src/common/TBC.sol";
import {FeeOnTransferERC20} from "src/example/ERC20/FeeOnTransferERC20.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
contract PoolFOTTokenTest is PoolCommonTest {
    function setUp() public endWithStopPrank {
        transferFee = 1000;
        pool = _setupFOTPool(false, TBCType.ALTBC);
        _setupCollateralToken();
    }

    function testLiquidity_Pool_FeeOnTransferToken_feeDeducted() public startAsAdmin endWithStopPrank {
        uint adminBalance = IERC20(pool.xToken()).balanceOf(address(admin));
        uint aliceBalance = IERC20(pool.xToken()).balanceOf(address(alice));
        uint amount = fullToken;
        uint fee = (fullToken * transferFee) / 10000;
        IERC20(pool.xToken()).transfer(address(alice), fullToken);
        assertEq(
            adminBalance,
            IERC20(pool.xToken()).balanceOf(address(admin)) + amount,
            "sender balance before transfer should equal balance after transfer + amount sent"
        );
        assertEq(
            aliceBalance + (amount - fee),
            IERC20(pool.xToken()).balanceOf(address(alice)),
            "receiver balance before transfer should equal balance after transfer + amount sent - fee"
        );
    }

    function testLiquidity_Pool_FeeOnTransferFromToken_feeDeducted() public startAsAdmin endWithStopPrank {
        uint adminBalance = IERC20(pool.xToken()).balanceOf(address(admin));
        uint aliceBalance = IERC20(pool.xToken()).balanceOf(address(alice));
        uint amount = fullToken;
        uint fee = (fullToken * transferFee) / 10000;
        IERC20(pool.xToken()).approve(alice, fullToken);
        vm.startPrank(alice);
        IERC20(pool.xToken()).transferFrom(admin, alice, fullToken);
        assertEq(
            adminBalance,
            IERC20(pool.xToken()).balanceOf(address(admin)) + amount,
            "sender balance before transfer should equal balance after transfer + amount sent"
        );
        assertEq(
            aliceBalance + (amount - fee),
            IERC20(pool.xToken()).balanceOf(address(alice)),
            "receiver balance before transfer should equal balance after transfer + amount sent - fee"
        );
    }
}
