// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;
    bool public isApproved = false;

    event Approved(uint balanceSent);

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    function approve() external payable {
        require(msg.sender == arbiter, "Only arbiter m8");
        uint contractBalance = address(this).balance;
        (bool s, ) = beneficiary.call{value: contractBalance}("");
        require(s, "Failed to send");
        isApproved = true;
        emit Approved(contractBalance);
    }
}
