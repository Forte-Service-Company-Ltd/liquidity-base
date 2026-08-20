// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "src/common/SVG/NFTSVG.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
}

contract MockPool {
    address public xToken;
    address public yToken;
    uint16 public fee;

    constructor(address _xToken, address _yToken, uint16 _fee) {
        xToken = _xToken;
        yToken = _yToken;
        fee = _fee;
    }

    function getFeeInfo() external view returns (uint16, uint16, address, address, uint256) {
        return (fee, 0, address(0), address(0), 0);
    }
}

contract ScratchRenderTest is Test {
    function test_render() public {
        // mimic screenshot sample: USDC / WstETH, token id 1, fee 1.00%
        ERC20 usdc = new MockERC20("USDC", "USDC");
        ERC20 wsteth = new MockERC20("WstETH", "WstETH");
        MockPool pool = new MockPool(address(usdc), address(wsteth), 100);

        string memory uri = Descriptor.constructTokenURI(1, address(pool), false);
        vm.writeFile("scratch_tokenuri.txt", uri);
    }
}
