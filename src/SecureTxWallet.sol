// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SecureTxWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function transferTo(address payable _to, uint256 _amount) public {
        require(msg.sender == owner, "Not owner");
        _to.transfer(_amount);
    }
}