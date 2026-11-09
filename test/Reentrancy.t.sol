// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {VulnerableBank} from "../src/VulnerableBank.sol";
import {Attacker} from "../src/Attacker.sol";
import {SecureBank} from "../src/SecureBank.sol";

contract ReentrancyTest is Test {
    VulnerableBank public bank;
    Attacker public attacker;

    function setUp() public {
        bank = new VulnerableBank();
        attacker = new Attacker(address(bank));

        address alice = makeAddr("alice");
        address bob = makeAddr("bob");
        vm.deal(alice, 5 ether);
        vm.deal(bob, 5 ether);

        vm.prank(alice);
        bank.deposit{value: 5 ether}();
        vm.prank(bob);
        bank.deposit{value: 5 ether}();
    }

    function test_attack() public {
        vm.deal(address(this), 1 ether);
        attacker.attack{value: 1 ether}();

        assertEq(address(bank).balance, 0);
        assertEq(address(attacker).balance, 11 ether);
    }

    function test_attack_fails_on_secure_bank() public {
        SecureBank secureBank = new SecureBank();
        Attacker attacker2 = new Attacker(address(secureBank));

        vm.deal(address(this), 11 ether);
        secureBank.deposit{value: 10 ether}();

        vm.expectRevert();
        attacker2.attack{value: 1 ether}();

        assertEq(address(secureBank).balance, 10 ether);
    }
}