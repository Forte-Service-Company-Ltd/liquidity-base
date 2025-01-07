/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {LPToken} from "src/common/LPToken.sol";
import "forge-std/console2.sol";
import {TestCommon} from "test/util/TestCommon.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract LPTokenTests is TestCommon {

    LPToken lpToken;
    uint256 w0 = 10_000_000;
    // We use this _pool instead of pool because pool is currently address(0), which cant be set to owner
    address _pool = address(0x9001);

    function setUp() public {
        lpToken = new LPToken("LP Token", "LPT", address(_pool), address(admin), w0);
    }

    function test_LPToken_SetGlobalWInConstructor() public {
        assertEq(lpToken.w(), w0);
    }

    function test_LPToken_ConstructorAssignsNameAndSymbolCorrectly() public {
        assertEq(lpToken.name(), "LP Token");
        assertEq(lpToken.symbol(), "LPT");
    }

    function test_LPToken_ConstructorAssignsPoolAddressAsOwner() public {
        assertEq(lpToken.owner(), address(_pool));
    }

    function test_LPToken_ConstructorMintsLPTokenToAdmin() public {
        assertEq(lpToken.balanceOf(admin), 1);
    }

    function test_LPToken_AssignVariablesOnMint() public {
        (uint256 rj, uint256 wj) = lpToken.lpToken(admin, 1);
        assertEq(rj, 0);
        assertEq(wj, w0);
    }

    function test_LPToken_MultipleLPs() public {
        // One token minted already. Next token minted will be tokenId 2, and so on.
        vm.startPrank(address(_pool));

        // TokenId 2
        uint256 _w = lpToken.w();
        lpToken.mint(ADDRESSES[0], 100, 0);
        (uint256 rj, uint256 wj) = lpToken.lpToken(ADDRESSES[0], 2);
        assertEq(rj, 0);
        assertEq(wj, _w + 100);

        // TokenId 3
        _w = lpToken.w();
        lpToken.mint(ADDRESSES[1], 500, 0);
        (rj, wj) = lpToken.lpToken(ADDRESSES[1], 3);
        assertEq(rj, 0);
        assertEq(wj, _w + 500);

        // TokenId 4
        _w = lpToken.w();
        lpToken.mint(ADDRESSES[2], 1000, 0);
        (rj, wj) = lpToken.lpToken(ADDRESSES[2], 4);
        assertEq(rj, 0);
        assertEq(wj, _w + 1000);
    }

    function test_LPToken_UpdateLPTokenVarsWithNewLiqDeposit_ZeroRjValue() public {
        (uint256 rj, uint256 wj) = lpToken.lpToken(address(admin), 1);
        assertEq(rj, 0);
        assertEq(wj, w0);

        vm.startPrank(address(_pool));
        lpToken.updateLPTokenDeposit(address(admin), 1, 1_000_000, 100);
        (uint256 rjUpdated, uint256 wjUpdated) = lpToken.lpToken(address(admin), 1);

        assertEq(rjUpdated, 9);
        assertEq(wjUpdated, wj + 1_000_000);
    }

    function test_LPToken_UpdateLPTokenVarsWithNewLiqDeposit_NonZeroRjValue() public {
        vm.startPrank(address(_pool));
        lpToken.updateLPTokenDeposit(address(admin), 1, 1_000, 100);
        (uint256 rj, uint256 wj) = lpToken.lpToken(address(admin), 1);

        lpToken.updateLPTokenDeposit(address(admin), 1, 1_000_000, 100);
        (uint256 rjUpdated, uint256 wjUpdated) = lpToken.lpToken(address(admin), 1);

        assertEq(rjUpdated, 9);
        assertEq(wjUpdated, wj + 1_000_000);
    }

    function test_LPToken_UpdateLPTokenVarsWithWithdrawal_Partial() public {
        (uint256 rj, uint256 wj) = lpToken.lpToken(address(admin), 1);
        assertEq(rj, 0);
        assertEq(wj, w0);

        vm.startPrank(address(_pool));
        lpToken.updateLPTokenWithdrawal(address(admin), 1, w0 / 2);
        (,uint256 wjUpdated) = lpToken.lpToken(address(admin), 1);
        assertEq(wjUpdated, w0 / 2);
    }

    function test_LPToken_UpdateLPTokenVarsWithWithdrawal_Full() public {
        (uint256 rj, uint256 wj) = lpToken.lpToken(address(admin), 1);
        assertEq(rj, 0);
        assertEq(wj, w0);
        assertEq(lpToken.balanceOf(address(admin)), 1);

        vm.startPrank(address(_pool));
        vm.expectEmit(true, true, true, true, address(lpToken));
        emit IERC721.Transfer(address(admin), address(0), 1);

        lpToken.updateLPTokenWithdrawal(address(admin), 1, w0);
        (,uint256 wjUpdated) = lpToken.lpToken(address(admin), 1);

        assertEq(wjUpdated, 0);
        assertEq(lpToken.balanceOf(address(admin)), 0);
    }
}