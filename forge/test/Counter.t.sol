// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {Vm} from "../lib/forge-std/src/Vm.sol";
import {IAssetCAS20} from "../src/interfaces/IAssetCAS20.sol";

contract CounterTest is Test {
    Counter public counter;
    IAssetCAS20 public asset;
    address alice = 0xa11ce;
    address bob = 0xb0b;

    function setUp() public {
        vm.startPrank(alice);
        {
            counter = new Counter();
            counter.createAsset(keccak256("idk"));
        }
        vm.stopPrank(alice);
    }

    function testMint(uint256 x) public {
        vm.startPrank(alice);
        {
            asset.mint(bob, x);
        }
        vm.stopPrank(alice);
    }
}
