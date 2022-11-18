// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import '../src/ExhaustedPigeonCard.sol';

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new ExhaustedPigeonCard();
    }
}
