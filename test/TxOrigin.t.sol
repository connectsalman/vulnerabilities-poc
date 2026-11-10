// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TxOriginWallet} from "../src/TxOriginWallet.sol";
import {SecureTxWallet} from "../src/SecureTxWallet.sol";
import {PhishingAttacker} from "../src/PhishingAttacker.sol";

contract TxOriginTest is Test {
    TxOriginWallet public wallet;
    PhishingAttacker public phishing;
    address public owner;
    address public attacker;

    function setUp() public {
        owner = makeAddr("owner");
        attacker = makeAddr("attacker");

        vm.prank(owner);
        wallet = new TxOriginWallet();
        vm.deal(address(wallet), 10 ether);

        vm.prank(attacker);
        phishing = new PhishingAttacker(payable(address(wallet)));
    }

    function test_phishing_steals_funds() public {
        vm.deal(owner, 1 ether);

        // the owner is tricked into sending ETH to the malicious contract
        vm.prank(owner, owner);
        (bool ok,) = address(phishing).call{value: 1 ether}("");
        assertTrue(ok);

        assertEq(address(wallet).balance, 0);
        assertEq(attacker.balance, 10 ether);
    }

    function test_phishing_fails_on_secure_wallet() public {
        vm.prank(owner);
        SecureTxWallet secureWallet = new SecureTxWallet();
        vm.deal(address(secureWallet), 10 ether);

        vm.prank(attacker);
        PhishingAttacker phishing2 = new PhishingAttacker(payable(address(secureWallet)));

        vm.deal(owner, 1 ether);
        vm.prank(owner, owner);
        (bool ok,) = address(phishing2).call{value: 1 ether}("");

        assertFalse(ok);
        assertEq(address(secureWallet).balance, 10 ether);
        assertEq(attacker.balance, 0);
    }
}
