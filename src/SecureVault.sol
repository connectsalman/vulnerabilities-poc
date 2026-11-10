// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SecureVault {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function setOwner(address _newOwner) public {
        require(msg.sender == owner, "Not owner");
        owner = _newOwner;
    }

    function withdraw() public {
        require(msg.sender == owner, "Not owner");
        payable(msg.sender).transfer(address(this).balance);
    }
}