// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Hero {
    bool public alerted;

    function alert() external {
        alerted = true;
    }
}

interface IHero {
    // interface for the Hero contract, acts like a mock
    function alert() external;
}

contract Sidekick {
    function sendAlert(address hero) external {
        // TODO: alert the hero using the IHero interface
        IHero(hero).alert();
    }
}

contract SidekickV2 {
    function sendAlert(address hero) external {
        // TODO: fill in the function signature
        bytes4 signature = bytes4(keccak256("alert()")); // Takes 4 bytes of the keccak256 hash of the function signature

        (bool success, ) = hero.call(abi.encodePacked(signature));

        require(success);
    }
}

contract SidekickV3 {
    function sendAlert(address hero, uint enemies, bool armed) external {
        // encodeWithSignature takes the function signature and the arguments
        // and returns the 4 bytes of the keccak256 hash of the function signature
        bytes memory payload = abi.encodeWithSignature(
            "alert(uint256,bool)",
            enemies,
            armed
        );
        (bool success, ) = hero.call(payload);

        require(success);
    }
}

contract SidekickV4 {
    function relay(address hero, bytes memory data) external {
        // send all of the data as calldata to the hero
        (bool s, ) = hero.call(data);
        require(s);
    }
}

contract SidekickV5 {
    function makeContact(address hero) external {
        // fails because the function signature is not correct
        bytes memory payload = abi.encodeWithSignature("someFoo(bool)", false);

        (bool s, ) = hero.call(payload);
        require(s);
    }
}
