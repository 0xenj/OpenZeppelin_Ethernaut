// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Fallback} from "../fallback/Fallback.sol";

contract FallbackTest is Test {
    address constant CONTRACT = address(42_000);
    address constant ATTACKER = address(42_001);
    Fallback fallbackContract;

    function setUp() public {
        // Set general test settings
        vm.roll(1);
        vm.warp(100);

        vm.prank(CONTRACT);
        fallbackContract = new Fallback();

        vm.stopPrank();
        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);
    }

    function test_Attack() public {
        console.log("-----------------------------------");
        console.logAddress(address(CONTRACT));
        console.logAddress(address(ATTACKER));
        assertEq(fallbackContract.owner(), CONTRACT);
        // vm.expectRevert("caller is not the owner");
        // vm.prank(ATTACKER);
        // test.withdraw();
    }
}
