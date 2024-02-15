// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Switch {
    address owner;
    address recipient;
    uint inactivityPeriod;

    constructor(address _recipient) payable {
        recipient = _recipient;
        owner = msg.sender;
        inactivityPeriod = block.timestamp;
    }

    function withdraw() external {
        require(block.timestamp >= inactivityPeriod + 52 weeks, "Not so fast");
        uint funds = address(this).balance;
        (bool s, ) = recipient.call{value: funds}("");
        require(s, "what?");
    }

    function ping() external {
        require(msg.sender == owner, "wtf");
        inactivityPeriod = block.timestamp;
    }
}
