// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";
import {IAssetCAS20} from "../src/interfaces/IAssetCAS20.sol";
import {IFactoryCAS20} from "../src/interfaces/IFactoryCAS20.sol";

contract CounterScript is Script {
    Counter public counter;

    function run(uint256 amount) public {
        address bob = address(0xb0b);
        bytes32 salt = keccak256("idk");
        vm.startBroadcast();
        counter = new Counter();
        vm.stopBroadcast();

        address factory = counter.cas20FactoryAddress();
        bytes memory prediction = vm.rpc(
            "eth_call",
            string.concat(
                '[{"to":"',
                vm.toString(factory),
                '","data":"',
                vm.toString(abi.encodeCall(IFactoryCAS20.getCAS20Address, (0, address(counter), salt))),
                '"},"latest"]'
            )
        );
        require(prediction.length == 32, "CAS20 factory unavailable on RPC node");
        address token = abi.decode(prediction, (address));

        // Forge's local EVM needs stand-ins for the BSC native calls.
        // The broadcast transactions execute against the real precompile.
        bytes memory mint = abi.encodeCall(IAssetCAS20.mint, (bob, amount));
        vm.mockCall(factory, IFactoryCAS20.createCAS20.selector, abi.encode(token));
        vm.mockCall(token, mint, "");

        vm.startBroadcast();
        counter.createAsset(salt);
        IAssetCAS20(token).mint(bob, amount);
        vm.stopBroadcast();
    }
}
