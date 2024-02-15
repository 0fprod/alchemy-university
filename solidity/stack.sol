// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract StackClub {
    address[] public members;

    constructor() {
        members.push(msg.sender);
    }

    function isMember(address addr) public view returns (bool) {
        bool flag = false;

        for (uint i = 0; i < members.length; i++) {
            if (members[i] == addr) {
                flag = true;
            }
        }
        return flag;
    }

    function addMember(address newMember) external {
        require(!isMember(newMember));
        members.push(newMember);
    }

    function removeLastMember() external {
        require(isMember(msg.sender));
        members.pop();
    }
}
