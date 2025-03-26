// import {Test} from "forge-std/Test.sol";
// import {Float128, packedFloat} from "../../lib/float128/src/Float128.sol";
// import {console2} from "forge-std/console2.sol";

// contract Quicktest is Test {
//     using Float128 for packedFloat;
//     mapping(uint256 => packedFloat) public wj;
//     mapping(uint256 => packedFloat) public rj;
//     function setUp() public {
//         wj[1] = packedFloat.wrap(0);
//         rj[1] = packedFloat.wrap(0);
//     }

//     function testFloat128_addition() public {
//         console2.log(wj[1].unwrap());
//         wj[1].add(packedFloat.wrap(100));
//         uint256 wj1 = wj[1].unwrap();
//         console2.log(wj1);
//     }
// }
