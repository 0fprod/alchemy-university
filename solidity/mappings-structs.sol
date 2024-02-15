// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Contract {
    struct User {
        uint balance;
        bool isActive;
    }

    mapping(address => User) public users;

    function createUser() external {
        if (users[msg.sender].isActive) {
            revert("No");
        }
        users[msg.sender] = User(100, true);
    }

    function transfer(address a, uint amount) external {
        User storage sender = users[msg.sender];
        User storage recipient = users[a];

        if (sender.isActive && recipient.isActive) {
            if (sender.balance >= amount) {
                sender.balance -= amount;
                recipient.balance += amount;
            } else {
                revert("Not enough balance m8");
            }
        } else {
            revert("No");
        }
    }
}

// NestedMappings
contract Contract2 {
    enum ConnectionTypes {
        Unacquainted,
        Friend,
        Family
    }

    // TODO: create a public nested mapping `connections`
    mapping(address => mapping(address => ConnectionTypes)) public connections;

    function connectWith(
        address other,
        ConnectionTypes connectionType
    ) external {
        // TODO: make the connection from msg.sender => other => connectionType
        connections[msg.sender][other] = connectionType;
    }
}
