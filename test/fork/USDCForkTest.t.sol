/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {GenericERC20} from "src/example/ERC20/GenericERC20.sol";
import {GenericERC20FixedSupply} from "src/example/ERC20/GenericERC20FixedSupply.sol";
import {ForkTestBase} from "test/fork/ForkTestBase.t.sol";

// Interface for interacting with USDC
interface IUSDC {
    function balanceOf(address account) external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function configureMinter(address minter, uint256 minterAllowedAmount) external;
    function masterMinter() external view returns (address);
}

/**
 * @title USDC Fork Testing
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
abstract contract USDCForkTest is ForkTestBase {

    function _setUp(address usdcAddress, string memory key) internal {
        IUSDC usdc = IUSDC(usdcAddress);
        uint256 fork = vm.createFork(vm.envString(key));
        vm.selectFork(fork);
        vm.prank(usdc.masterMinter());
        usdc.configureMinter(address(this), type(uint256).max);
        usdc.mint(address(this), 1e12 * STABLECOIN_DEC);

        admin = address(this);
        yToken = GenericERC20(address(usdc));
        pool = _setupPoolForkTest(address(this), address(usdc), 0, false);
        _yToken = IERC20(pool.yToken());
        xToken = GenericERC20FixedSupply(address(pool.xToken()));
        withStableCoin = true;
    }

    function testMoreThanApprovedFor() public startAsAdmin {
        _yToken.approve(address(this), STABLECOIN_DEC);
        _yToken.approve(address(pool), STABLECOIN_DEC);

        (uint expected, , ) = pool.simSwap(address(_yToken), 1e2 * STABLECOIN_DEC);
        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        pool.swap(address(_yToken), 1e12 * STABLECOIN_DEC, expected);
    }

    function testNotEnoughCollateral() public startAsAdmin {
        _yToken.approve(address(this), 1e14 * STABLECOIN_DEC);
        _yToken.approve(address(pool), 1e14 * STABLECOIN_DEC);
        (uint expected, , ) = pool.simSwap(address(_yToken), 1e3 * STABLECOIN_DEC);
        uint balance = _yToken.balanceOf(address(this));
        _yToken.transfer(address(alice), balance - 1);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        pool.swap(address(_yToken), 1e13 * STABLECOIN_DEC, expected);
    }
}

/**
 * @title USDC Mainnet Fork Testing
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
contract USDCMainnetForkTest is USDCForkTest {
    function setUp() public {
        _setUp(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), "ETHEREUM_RPC_KEY");
    }
}

/**
 * @title USDC Polygon Fork Testing
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
contract USDCPolygonForkTest is USDCForkTest {
    function setUp() public {
        _setUp(address(0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359), "POLYGON_RPC_KEY");
    }
}