pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {CoinFlip} from "../03 coin flip/CoinFlip.sol";

contract CoinFlip is Test {
    address constant CONTRACT = address(42_000);
    address constant ATTACKER = address(42_001);
    CoinFlip coinflipContract;

    function setUp() public {
        // Set general test settings
        vm.roll(1);
        vm.warp(100);
        vm.deal(CONTRACT, 1000000000000000000);
        vm.deal(ATTACKER, 1000000000000000000);

        vm.prank(CONTRACT);
        coinflipContract = new CoinFlip();

        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);
    }
}
