// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Party {
    uint partyFee;
    address[] members;

    constructor(uint fee) {
        partyFee = fee;
    }

    function rsvp() external payable IsNotMember(msg.sender) {
        require(msg.value == partyFee);
        members.push(msg.sender);
    }

    modifier IsNotMember(address addrs) {
        bool flag = false;
        uint i = 0;
        while (i < members.length && flag == false) {
            if (members[i] == addrs) {
                flag = true;
            }
            i++;
        }

        if (flag == false) {
            _;
        } else {
            revert("Not again!");
        }
    }

    function payBill(address venue, uint totalCost) external {
        uint contractBalance = address(this).balance;
        (bool s, ) = venue.call{value: totalCost}("");
        require(s, "Could not pay to Venue");
        uint remainder = contractBalance - totalCost;
        uint eachMemberReceives = remainder / members.length;

        for (uint i = 0; i < members.length; i++) {
            (bool ss, ) = members[i].call{value: eachMemberReceives}("");
            require(ss, "Could not pay to some member");
        }
    }
}
