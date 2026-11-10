// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {VulnerableVault} from "../src/VulnerableVault.sol";
import {SecureVault} from "../src/SecureVault.sol";

contract AccessControlTest is Test {
    VulnerableVault public vault;

    function setUp() public {
        vault = new VulnerableVault();
        vm.deal(address(vault), 10 ether);
    }

    function test_anyone_can_take_over() public {
        address attacker = makeAddr("attacker");

        vm.startPrank(attacker);
        vault.setOwner(attacker);
        vault.withdraw();
        vm.stopPrank();

        assertEq(address(vault).balance, 0);
        assertEq(attacker.balance, 10 ether);
    }

    function test_takeover_fails_on_secure_vault() public {
        SecureVault secureVault = new SecureVault();
        vm.deal(address(secureVault), 10 ether);
        address attacker = makeAddr("attacker");

        vm.prank(attacker);
        vm.expectRevert("Not owner");
        secureVault.setOwner(attacker);

        assertEq(secureVault.owner(), address(this));
        assertEq(address(secureVault).balance, 10 ether);
    }
}