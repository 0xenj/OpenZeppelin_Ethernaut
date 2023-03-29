// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Fallback} from "../fallback/Fallback.sol";
import {MockERC20} from "../mock/MockERC20.sol";

contract FallbackTest is Test {
    Fallback public test;

    MockERC20 public token;

    function setUp() public {
        // Set general test settings
        vm.roll(1);
        vm.warp(100);
        vm.startPrank(ADMIN);

        test = new Fallback();

        token = new MockERC20();

        vm.stopPrank();
        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);

        return test;
    }
}
