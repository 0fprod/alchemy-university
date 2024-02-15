// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Collectible {
    address public owner;
    uint price;

    event Deployed(address indexed owner);
    event Transfer(address indexed from, address indexed to);
    event ForSale(uint price, uint timestamp);
    event Purchase(uint amount, address indexed buyer);

    constructor() {
        owner = msg.sender;
        emit Deployed(owner);
    }

    function transfer(address to) external {
        require(msg.sender == owner);
        address formerOwner = owner;
        address newOwner = to;

        owner = newOwner;
        emit Transfer(formerOwner, newOwner);
    }

    function markPrice(uint _price) external {
        require(msg.sender == owner);
        require(_price > 0);
        price = _price;
        emit ForSale(_price, block.timestamp);
    }

    function purchase() external payable {
        require(price > 0);
        address buyer = msg.sender;
        uint amount = msg.value;
        require(amount >= price);

        (bool s, ) = owner.call{value: amount}("");
        require(s);
        owner = buyer;
        price = 0;

        emit Purchase(amount, buyer);
    }
}
